package org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.rules

import org.apache.log4j.Logger
import org.eclipse.viatra.examples.cps.deployment.BehaviorState
import org.eclipse.viatra.examples.cps.deployment.BehaviorTransition
import org.eclipse.viatra.examples.cps.deployment.DeploymentApplication
import org.eclipse.viatra.examples.cps.deployment.DeploymentBehavior
import org.eclipse.viatra.examples.cps.deployment.DeploymentFactory
import org.eclipse.viatra.examples.cps.deployment.DeploymentHost
import org.eclipse.viatra.examples.cps.deployment.DeploymentPackage
import org.eclipse.viatra.examples.cps.traceability.CPS2DeplyomentTrace
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.traceability.TraceabilityFactory
import org.eclipse.viatra.examples.cps.traceability.TraceabilityPackage
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.ApplicationInstanceMatcher
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.CpsXformM2M
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.HostInstanceMatcher
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.StateMachineMatcher
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.StateMatcher
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.TransitionMatcher
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.patterns.TriggerPairMatcher
import org.eclipse.viatra.query.runtime.api.IPatternMatch
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.query.runtime.api.ViatraQueryMatcher
import org.eclipse.viatra.transformation.evm.specific.crud.CRUDActivationStateEnum
import org.eclipse.viatra.transformation.evm.specific.lifecycle.DefaultActivationLifeCycle
import org.eclipse.viatra.transformation.runtime.emf.modelmanipulation.IModelManipulations
import org.eclipse.viatra.transformation.runtime.emf.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.transformation.runtime.emf.rules.eventdriven.EventDrivenTransformationRule
import org.eclipse.viatra.transformation.runtime.emf.rules.eventdriven.EventDrivenTransformationRuleFactory

public class RuleProvider {

	extension Logger logger = Logger.getLogger("cps.xform.m2m.incr.viatra")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	extension IModelManipulations manipulation
	extension DeploymentPackage depPackage = DeploymentPackage::eINSTANCE
	extension TraceabilityPackage trPackage = TraceabilityPackage::eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	extension EventDrivenTransformationRuleFactory factory = new EventDrivenTransformationRuleFactory
	CPSToDeployment cps2dep
	ViatraQueryEngine engine

	EventDrivenTransformationRule<? extends IPatternMatch, ? extends ViatraQueryMatcher<?>> hostRule
	EventDrivenTransformationRule<? extends IPatternMatch, ? extends ViatraQueryMatcher<?>> applicationRule
	EventDrivenTransformationRule<? extends IPatternMatch, ? extends ViatraQueryMatcher<?>> stateMachineRule
	EventDrivenTransformationRule<? extends IPatternMatch, ? extends ViatraQueryMatcher<?>> stateRule
	EventDrivenTransformationRule<? extends IPatternMatch, ? extends ViatraQueryMatcher<?>> transitionRule
	EventDrivenTransformationRule<? extends IPatternMatch, ? extends ViatraQueryMatcher<?>> triggerRule

	new(ViatraQueryEngine engine, CPSToDeployment cps2dep) {
		this.engine = engine
		this.cps2dep = cps2dep
		manipulation = new SimpleModelManipulations(engine)
	}

	public def getHostRule() {
		if (hostRule == null) {
			hostRule = createRule.precondition(HostInstanceMatcher.querySpecification).action(
				CRUDActivationStateEnum.CREATED) [
				val hostinstance = hostInstance
				val nodeIp = hostInstance.nodeIp
				debug('''Mapping host with IP: «nodeIp»''')
				val host = createDeploymentHost => [
					ip = nodeIp
				]
				cps2dep.deployment.hosts += host
				cps2dep.traces += createCPS2DeplyomentTrace => [
					cpsElements += hostinstance
					deploymentElements += host
				]
			].action(CRUDActivationStateEnum.UPDATED) [
				val depHost = engine.cps2depTrace.getOneArbitraryMatch(cps2dep, null, hostInstance, null).depElement as DeploymentHost
				val hostIp = depHost.ip
				debug('''Updating mapped host with IP: «hostIp»''')
				val nodeIp = hostInstance.nodeIp
				depHost.set(deploymentHost_Ip, nodeIp)
				debug('''Updated mapped host with IP: «nodeIp»''')
			].action(CRUDActivationStateEnum.DELETED) [
				val traceMatch = engine.cps2depTrace.getOneArbitraryMatch(cps2dep, null, hostInstance, null)
				val hostIp = hostInstance.nodeIp
				logger.debug('''Removing host with IP: «hostIp»''')
				cps2dep.deployment.hosts -= traceMatch.depElement as DeploymentHost
				cps2dep.remove(CPSToDeployment_Traces, traceMatch.trace)
				logger.debug('''Removed host with IP: «hostIp»''')
			].addLifeCycle(DefaultActivationLifeCycle.DEFAULT).build

		}
		return hostRule
	}

	public def getApplicationRule() {
		if (applicationRule == null) {

			applicationRule = createRule.precondition(ApplicationInstanceMatcher.querySpecification).action(
				CRUDActivationStateEnum.CREATED) [
				val depHost = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance.allocatedTo).
					filter(DeploymentHost).head
				val appinstance = appInstance
				val appId = appInstance.id
				debug('''Mapping application with ID: «appId»''')
				val app = createDeploymentApplication => [
					id = appId
				]
				depHost.applications += app
				cps2dep.traces += createCPS2DeplyomentTrace => [
					cpsElements += appinstance
					deploymentElements += app
				]
				debug('''Mapped application with ID: «appId»''')
			].action(CRUDActivationStateEnum.UPDATED) [
				val depApp = engine.cps2depTrace.getOneArbitraryMatch(cps2dep, null, appInstance, null).depElement as DeploymentApplication
				if (depApp.id != appInstance.id)
					depApp.id = appInstance.id
			].action(CRUDActivationStateEnum.DELETED) [
				val trace = engine.cps2depTrace.getAllValuesOftrace(null, appInstance, null).head as CPS2DeplyomentTrace
				val depApp = trace.deploymentElements.head as DeploymentApplication
				engine.allocatedDeploymentApplication.getAllValuesOfdepHost(depApp).head.applications -= depApp
				cps2dep.traces -= trace
				
			].addLifeCycle(DefaultActivationLifeCycle.DEFAULT).build

		}
		return applicationRule
	}

	public def getStateMachineRule() {
		if (stateMachineRule == null) {
			stateMachineRule = createRule.precondition(StateMachineMatcher.querySpecification).action(
				CRUDActivationStateEnum.CREATED) [
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).filter(
					DeploymentApplication).head
				val smId = stateMachine.id
				debug('''Mapping state machine with ID: «smId»''')
				val behavior = depApp.createChild(deploymentApplication_Behavior, deploymentBehavior) as DeploymentBehavior
				behavior.set(deploymentElement_Description, smId)
				depApp.set(deploymentApplication_Behavior, behavior)
				val traces = engine.cps2depTrace.getAllValuesOftrace(null, stateMachine, null)
				if (traces.empty) {
					trace('''Creating new trace for state machine''')
					val trace = cps2dep.createChild(CPSToDeployment_Traces, CPS2DeplyomentTrace)
					trace.addTo(CPS2DeplyomentTrace_CpsElements, stateMachine)
					trace.addTo(CPS2DeplyomentTrace_DeploymentElements, behavior)

				} else {
					trace('''Adding new behavior to existing trace''')
					traces.head.addTo(CPS2DeplyomentTrace_DeploymentElements, behavior)
				}
				debug('''Mapped state machine with ID: «smId»''')
			].action(CRUDActivationStateEnum.UPDATED) [
				val smId = stateMachine.id
				debug('''Updating mapped state machine with ID: «smId»''')
				val depSMs = engine.cps2depTrace.getAllValuesOfdepElement(null, null, stateMachine).filter(
					DeploymentBehavior)
				depSMs.forEach [
					if (description != smId) {
						trace('''ID changed to �smId�''')
						description = smId
					}
				]
				debug('''Updated mapped state machine with ID: «smId»''')
			].action(CRUDActivationStateEnum.DELETED) [
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).head as DeploymentApplication;
				val depBehavior = depApp.behavior
				val smId = depBehavior.description
				logger.debug('''Removing state machine with ID: «smId»''')
				depApp.behavior = null;
				val smTrace = engine.cps2depTrace.getAllValuesOftrace(null, stateMachine, null).head
				smTrace.deploymentElements -= depBehavior
				if (smTrace.deploymentElements.empty) {
					trace('''Removing empty trace''')
					cps2dep.traces -= smTrace
				}
				logger.debug('''Removed state machine with ID: «smId»''')
			].addLifeCycle(DefaultActivationLifeCycle.DEFAULT).build

		}
		return stateMachineRule
	}

	public def getStateRule() {
		if (stateRule == null) {
			stateRule = createRule.precondition(StateMatcher.querySpecification).action(
				CRUDActivationStateEnum.CREATED) [
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).head as DeploymentApplication
				val depBehavior = depApp.behavior
				val state = state
				val stateId = state.id
				debug('''Mapping state with ID: «stateId»''')
				val depState = createBehaviorState => [
					description = stateId
				]
				depBehavior.states += depState
				if (stateMachine.initial == state) {
					depBehavior.current = depState
				}
				val traces = engine.cps2depTrace.getAllValuesOftrace(null, state, null)
				if (traces.empty) {
					trace('''Creating new trace for state ''')
					cps2dep.traces += createCPS2DeplyomentTrace => [
						cpsElements += state
						deploymentElements += depState
					]
				} else {
					trace('''Adding new state to existing trace''')
					traces.head.deploymentElements += depState
				}
				debug('''Mapped state with ID: «stateId»''')
			].action(CRUDActivationStateEnum.UPDATED) [
				val state = state
				val stateId = state.id
				debug('''Updating mapped state with ID: «stateId»''')
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).filter(
					DeploymentApplication).head
				val depState = engine.cps2depTrace.getAllValuesOfdepElement(null, null, state).filter(BehaviorState).
					findFirst[depApp.behavior.states.contains(it)]
				val depBehavior = depApp.behavior
				val oldDesc = depState.description
				if (oldDesc != stateId) {
					trace('''ID changed to «stateId»''')
					depState.description = stateId
				}
				val initState = stateMachine.initial
				if (state == initState) {
					val currentState = depBehavior.current
					if (currentState != depState) {
						trace('''Current state changed to «stateId»''')
						depBehavior.current = depState
					}
				}
				debug('''Updated mapped state with ID: «stateId»''')
			].action(CRUDActivationStateEnum.DELETED) [
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).head as DeploymentApplication
				val depBehavior = depApp.behavior
				val depState = engine.cps2depTrace.getAllValuesOfdepElement(null, null, state).filter(BehaviorState).
					findFirst[depApp.behavior.states.contains(it)];
				val stateId = depState.description
				logger.debug('''Removing state with ID: «stateId»''')
				if (depBehavior != null) {
					depBehavior.states -= depState
					if (depBehavior.current == depState) {
						depBehavior.current = null
					}
				}
				val smTrace = engine.cps2depTrace.getAllValuesOftrace(null, state, null).head
				smTrace.deploymentElements -= depState
				if (smTrace.deploymentElements.empty) {
					trace('''Removing empty trace''')
					cps2dep.traces -= smTrace
				}
				logger.debug('''Removed state with ID: «stateId»''')
			].addLifeCycle(DefaultActivationLifeCycle.DEFAULT).build

		}
		return stateRule
	}

	public def getTransitionRule() {
		if (transitionRule == null) {
			transitionRule = createRule.precondition(TransitionMatcher.querySpecification).action(
				CRUDActivationStateEnum.CREATED) [
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).filter(
					DeploymentApplication).head
				val transition = transition
				val transitionId = transition.id
				debug('''Mapping transition with ID: «transitionId»''')
				val depTransition = createBehaviorTransition => [
					description = transitionId
				]
				depApp.behavior.transitions += depTransition
				val tempDepSources = engine.cps2depTrace.getAllValuesOfdepElement(null, null, srcState);
				val depSource = depApp.behavior.states.findFirst[tempDepSources.contains(it)]
				depSource.outgoing += depTransition
				val tempDepTargets = engine.cps2depTrace.getAllValuesOfdepElement(null, null, transition.targetState);
				val depTarget = depApp.behavior.states.findFirst[tempDepTargets.contains(it)]
				depTransition.to = depTarget
				val traces = engine.cps2depTrace.getAllValuesOftrace(null, transition, null)
				if (traces.empty) {
					trace('''Creating new trace for transition ''')
					cps2dep.traces += createCPS2DeplyomentTrace => [
						cpsElements += transition
						deploymentElements += depTransition
					]
				} else {
					trace('''Adding new transition to existing trace''')
					traces.head.deploymentElements += depTransition
				}
				debug('''Mapped transition with ID: «transitionId»''')
			].action(CRUDActivationStateEnum.UPDATED) [
				val transition = transition
				val trId = transition.id
				debug('''Updating mapped transition with ID: «trId»''')
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).filter(
					DeploymentApplication).head
				val depTransitions = engine.cps2depTrace.getAllValuesOfdepElement(null, null, transition).filter(
					BehaviorTransition).toSet
				val depTransition = depApp.behavior.transitions.findFirst[depTransitions.contains(it)]
				val oldDesc = depTransition.description
				if (oldDesc != trId) {
					trace('''ID changed to «oldDesc»''')
					depTransition.description = trId
				}
				val tempDepSources = engine.cps2depTrace.getAllValuesOfdepElement(null, null, srcState)
				val depSource = depApp.behavior.states.findFirst[tempDepSources.contains(it)]
				val tempDepTargets = engine.cps2depTrace.getAllValuesOfdepElement(null, null, transition.targetState);
				val depTarget = depApp.behavior.states.findFirst[tempDepTargets.contains(it)]
				if (!depSource.outgoing.contains(depTransition)) {
					trace('''Source state changed to «depSource.description»''')
					depSource.outgoing += depTransition
				}
				if (depTransition.to != depTarget) {
					trace('''Target state changed to «depTarget.description»''')
					depTransition.to = depTarget
				}
				debug('''Updated mapped transition with ID: «trId»''')
			].action(CRUDActivationStateEnum.DELETED) [
				val transition = transition
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstance).filter(
					DeploymentApplication).head
				val depTransitions = engine.cps2depTrace.getAllValuesOfdepElement(null, null, transition).filter(
					BehaviorTransition).toSet
				val depTransition = engine.depBehaviorsStateAndTransitions.
					getAllValuesOfdepTransition(depApp.behavior, null).findFirst[depTransitions.contains(it)]
				val trId = depTransition.description
				logger.debug('''Removing transition with ID: «trId»''')
				depTransition.to = null
				val tempDepSources = engine.cps2depTrace.getAllValuesOfdepElement(null, null, srcState)
				val depSource = depApp.behavior.states.findFirst[tempDepSources.contains(it)]
				depSource?.outgoing -= depTransition;
				depApp.behavior.transitions -= depTransition
				val smTrace = engine.cps2depTrace.getAllValuesOftrace(null, transition, null).head
				smTrace.deploymentElements -= depTransition
				if (smTrace.deploymentElements.empty) {
					trace('''Removing empty trace''')
					cps2dep.traces -= smTrace
				}
				logger.debug('''Removed transition with ID: «trId»''')
			].addLifeCycle(DefaultActivationLifeCycle.DEFAULT).build

		}
		return transitionRule
	}

	public def getTriggerRule() {
		if (triggerRule == null) {
			triggerRule = createRule.precondition(TriggerPairMatcher.querySpecification).action(
				CRUDActivationStateEnum.CREATED) [
				val depAppTrigger = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstanceTrigger).
					filter(DeploymentApplication).head
				val depAppTarget = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstanceTarget).
					filter(DeploymentApplication).head
				val sendTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsTrigger).filter(
					BehaviorTransition).findFirst[depAppTrigger.behavior.transitions.contains(it)]
				val waitTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsTarget).filter(
					BehaviorTransition).findFirst[depAppTarget.behavior.transitions.contains(it)]
				debug('''Mapping trigger between «sendTr.description» and «waitTr.description»''')
				if (!sendTr.trigger.contains(waitTr)) {
					trace('''Adding new trigger''')
					sendTr.trigger += waitTr
				}
				debug('''Mapped trigger between «sendTr.description» and «waitTr.description»''')
			].action(CRUDActivationStateEnum.DELETED) [
				val depAppTrigger = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstanceTrigger).
					filter(DeploymentApplication).head
				val depAppTarget = engine.cps2depTrace.getAllValuesOfdepElement(null, null, appInstanceTarget).
					filter(DeploymentApplication).head
				val sendTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsTrigger).filter(
					BehaviorTransition).findFirst[depAppTrigger.behavior.transitions.contains(it)]
				val waitTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, cpsTarget).filter(
					BehaviorTransition).findFirst[depAppTarget.behavior.transitions.contains(it)]
				debug('''Removing trigger between «sendTr.description» and «waitTr.description»''')
				if (sendTr.trigger.contains(waitTr)) {
					trace('''Removing existing trigger''')
					sendTr.trigger -= waitTr
				}
				debug('''Removing trigger between «sendTr.description» and «waitTr.description»''')
			].addLifeCycle(DefaultActivationLifeCycle.DEFAULT).build

		}
		return triggerRule
	}
}
