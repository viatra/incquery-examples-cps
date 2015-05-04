package org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.rules

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.AppInstanceWithStateMachineMatcher
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.ApplicationInstanceMatcher
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.Cps2depTraceMatcher
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.HostInstanceMatcher
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.StateMatcher
import org.eclipse.incquery.runtime.api.IPatternMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.api.IncQueryMatcher
import org.eclipse.viatra.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRule
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.TransitionMatcher
import org.eclipse.incquery.examples.cps.deployment.BehaviorState

class RuleProvider {
	extension Logger logger = Logger.getLogger("cps.xform.m2m.batch.viatra")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	extension BatchTransformationRuleFactory = new BatchTransformationRuleFactory
	extension IModelManipulations manipulation
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	CPSToDeployment mapping
	IncQueryEngine engine
	
	BatchTransformationRule<? extends IPatternMatch, ? extends IncQueryMatcher<?>> hostRule
	BatchTransformationRule<? extends IPatternMatch, ? extends IncQueryMatcher<?>> applicationRule
	BatchTransformationRule<? extends IPatternMatch, ? extends IncQueryMatcher<?>> stateMachineRule
	BatchTransformationRule<? extends IPatternMatch, ? extends IncQueryMatcher<?>> stateRule
	BatchTransformationRule<? extends IPatternMatch, ? extends IncQueryMatcher<?>> transitionRule
	
	new(IncQueryEngine engine, CPSToDeployment deployment) {
		this.mapping = deployment
		this.engine = engine
		manipulation = new SimpleModelManipulations(engine)
	}
	
	
	public def getHostRule() {
		if (hostRule == null) {
			hostRule = createRule(HostInstanceMatcher.querySpecification)[
				val cpsHostInstance = it.hostInstance
				val nodeIp = it.hostInstance.nodeIp
				debug('''Mapping host with IP: «nodeIp»''')
				val deploymentHost = createDeploymentHost => [
					ip = nodeIp
				]
				mapping.deployment.hosts += deploymentHost
				mapping.traces += createCPS2DeplyomentTrace => [
					cpsElements += cpsHostInstance
					deploymentElements += deploymentHost
				]
			]
		}
		return hostRule
	}
	
	public def getApplicationRule() {
		if (applicationRule == null) {
			applicationRule = createRule(ApplicationInstanceMatcher.querySpecification)[
				val cpsApplicationInstance = it.appInstance
				val appId = it.appInstance.id
				
				val cpsHostInstance = cpsApplicationInstance.allocatedTo
				val depHost = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsHostInstance).filter(DeploymentHost).head
				
				debug('''Mapping application with ID: «appId»''')
				val deploymentApplication = createDeploymentApplication => [
					id = appId
				]
				
				
				mapping.traces += createCPS2DeplyomentTrace => [
					cpsElements += cpsApplicationInstance
					deploymentElements += deploymentApplication
				]
				depHost.applications += deploymentApplication
				debug('''Mapped application with ID: «appId»''')
			]
		}
		return applicationRule
	}
	
	public def getStateMachineRule() {
		if (stateMachineRule == null) {
			stateMachineRule = createRule(AppInstanceWithStateMachineMatcher.querySpecification)[
				val cpsApplicationInstance = it.appInstance
				val cpsStateMachine = it.stateMachine
				
				val depApplication = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsApplicationInstance).filter(DeploymentApplication).head
				val depBehavior = createDeploymentBehavior => [
					description = cpsStateMachine.id
				]
				depApplication.behavior = depBehavior
				
				val trace = getTraceForCPSElement(cpsStateMachine)
				if (trace == null){
					mapping.traces += createCPS2DeplyomentTrace => [
						cpsElements += cpsStateMachine
						deploymentElements += depBehavior
					]
				} else {
					trace.deploymentElements += depBehavior
				}
				
			]
		}
		return stateMachineRule
	}
	
	public def getStateRule() {
		if (stateRule == null) {
			stateRule = createRule(StateMatcher.querySpecification)[
				val cpsStateMachine = it.stateMachine
				val cpsAppInstance = it.appInstance
				val cpsState = it.state
				
				val behaviorState = createBehaviorState => [
					description = cpsState.id
				]
				
				val appInstanceTrace = getTraceForCPSElement(cpsAppInstance)
				val depApplication = appInstanceTrace.deploymentElements.filter(DeploymentApplication).head
				val depBehavior = depApplication.behavior
				depBehavior.states += behaviorState
				
				val trace = getTraceForCPSElement(cpsState)
				if (trace == null) {
					mapping.traces += createCPS2DeplyomentTrace => [
						cpsElements += cpsState
						deploymentElements += behaviorState
					]
				} else {
					trace.deploymentElements += behaviorState
				}
				
				if (cpsStateMachine.initial == cpsState) {
					depBehavior.current = behaviorState
				}
			]
		}
		return stateRule
	}
	
	public def getTransitionRule() {
		if (transitionRule == null) {
			transitionRule = createRule(TransitionMatcher.querySpecification)[
				val cpsAppInstance = it.appInstance
				val cpsState = it.sourceState
				val cpsTargetState = it.targetState
				val cpsTransition = it.transition  
				
				
				val behaviorTransition = createBehaviorTransition => [
					description = cpsTransition.id
				]
				
				val appInstanceTrace = getTraceForCPSElement(cpsAppInstance)
				val depApplication = appInstanceTrace.deploymentElements.filter(DeploymentApplication).head
				val depBehavior = depApplication.behavior
				depBehavior.transitions += behaviorTransition
				
				val trace = getTraceForCPSElement(cpsTransition)
				if (trace == null){
					mapping.traces += createCPS2DeplyomentTrace => [
						cpsElements += cpsTransition
						deploymentElements += behaviorTransition
					]
				} else {
					trace.deploymentElements += behaviorTransition
				}
				
				val depTargetState = depBehavior.states.filter[description == cpsTargetState.id].head
				val depSourceState = depBehavior.states.filter[description == cpsState.id].head
				
				depSourceState.outgoing += behaviorTransition
				behaviorTransition.to = depTargetState
			]
		}
		return transitionRule
	}
	
	def getTraceForCPSElement(Identifiable cpsElement) {
		engine.cps2depTrace.getAllValuesOftrace(null, cpsElement, null).filter(CPS2DeplyomentTrace).head
	}
}