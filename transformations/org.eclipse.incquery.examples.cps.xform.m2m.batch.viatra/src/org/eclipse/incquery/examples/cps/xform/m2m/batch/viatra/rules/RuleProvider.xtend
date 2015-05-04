package org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.rules

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.ApplicationInstanceMatcher
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.HostInstanceMatcher
import org.eclipse.incquery.runtime.api.IPatternMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.api.IncQueryMatcher
import org.eclipse.viatra.emf.runtime.modelmanipulation.IModelManipulations
import org.eclipse.viatra.emf.runtime.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRule
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.Cps2depTraceMatcher
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.CpsXformM2M
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.AppInstanceWithStateMachineMatcher
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace

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
				val cpsApplicationInstance = it.applicationInstance
				val appId = it.applicationInstance.id
				
				
				val cpsHostInstance = cpsApplicationInstance.allocatedTo
				val depHost = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsHostInstance).filter(DeploymentHost).head
				if (depHost == null || cpsHostInstance == null) return;
				
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
				val cpsApplicationType = it.appType
				val cpsStateMachine = it.stateMachine
				
				val depApplication = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsApplicationInstance).filter(DeploymentApplication).head
				val depBehaviour = createDeploymentBehavior => [
					description = cpsStateMachine.id
				]
				depApplication.behavior = depBehaviour
				
				val trace = engine.cps2depTrace.getAllValuesOftrace(null, cpsStateMachine, null).filter(CPS2DeplyomentTrace).head
				if (trace == null){
					mapping.traces += createCPS2DeplyomentTrace => [
						cpsElements += cpsStateMachine
						deploymentElements += depBehaviour
					]
				} else {
					trace.deploymentElements += depBehaviour
				}
				
			]
		}
		return stateMachineRule
	}
}