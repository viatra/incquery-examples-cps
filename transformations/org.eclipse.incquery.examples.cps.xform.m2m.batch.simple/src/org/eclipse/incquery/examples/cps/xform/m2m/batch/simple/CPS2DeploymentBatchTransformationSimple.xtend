package org.eclipse.incquery.examples.cps.xform.m2m.batch.simple

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import java.util.ArrayList
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory

import static com.google.common.base.Preconditions.*
import static extension org.eclipse.incquery.examples.cps.xform.m2m.util.SignalUtil.*
import static extension org.eclipse.incquery.examples.cps.xform.m2m.util.NamingUtil.*

class CPS2DeploymentBatchTransformationSimple {

	extension Logger logger = Logger.getLogger("cps.xform.CPS2DeploymentTransformation")

	private def traceBegin(String method) {
		trace('''Executing «method» BEGIN''')
	}

	private def traceEnd(String method) {
		trace('''Executing «method» END''')
	}

	CPSToDeployment mapping;

	/**
	 * Creates a new transformation instance. The input CyberPhisicalSystem model is given in the mapping
	 * @param mapping the traceability model root
	 */
	new(CPSToDeployment mapping) {
		traceBegin("constructor")

		checkNotNull(mapping != null, "Mapping cannot be null!")
		checkArgument(mapping.cps != null, "CPS not defined in mapping!")
		checkArgument(mapping.deployment != null, "Deployment not defined in mapping!")

		this.mapping = mapping;

		traceEnd("constructor")
	}

	/**
	 * Executes the simple batch transformation. The transformed model is placed in the traceability model set in the constructor 
	 */
	def void execute() {
		traceBegin("execute()")

		mapping.traces.clear
		mapping.deployment.hosts.clear

		// Transform host instances
		val hosts = mapping.cps.hostInstances
		val deploymentHosts = ImmutableList.copyOf(hosts.map[transform])
		mapping.deployment.hosts += deploymentHosts

		assignTriggers
		traceEnd("execute()")
	}

	/**
	 * Sets the <code>triggers</code> reference of the behavior transitions according to the transitions action.
	 * <br>
	 * Call this method only after the all the model elements (nodes) are transformed and exist in the target model.
	 */
	private def assignTriggers() {
		traceBegin("assignTriggers()")

		val transitionMappings = mapping.traces.filter[deploymentElements.head instanceof BehaviorTransition]
		val senderTransitionMappings = transitionMappings.filter[isTraceForSender]
		senderTransitionMappings.forEach[findReceivers]

		traceEnd("assignTriggers()")
	}

	def findReceivers(CPS2DeplyomentTrace senderTransitonTrace) {
		traceBegin('''findReceivers(«senderTransitonTrace.name»)''')

		var receiverTraces = mapping.traces.filter[deploymentElements.head instanceof BehaviorTransition]
		receiverTraces.forEach[setTriggerIfConnected(senderTransitonTrace)]

		traceEnd('''findReceivers(«senderTransitonTrace.name»)''')
	}

	def void setTriggerIfConnected(CPS2DeplyomentTrace receiverTrace, CPS2DeplyomentTrace senderTrace) {
		traceBegin('''setTriggerIfConnected(«receiverTrace.name»,«senderTrace.name»)''')

		if (!isTraceForReceiver(receiverTrace))
			return;

		// a trace here refers to BehaviorTransitions
		for (i : receiverTrace.deploymentElements) {
			for (j : senderTrace.deploymentElements) {
				val receiverBehaviorTransition = i as BehaviorTransition
				val receiverDeploymentApp = receiverBehaviorTransition.eContainer.eContainer as DeploymentApplication
				val receiverDeploymentHost = receiverDeploymentApp.eContainer as DeploymentHost
				val receiverHostInstance = mapping.traces.findFirst[it.deploymentElements.head == receiverDeploymentHost].
					cpsElements.head as HostInstance

				val senderBehaviorTransition = j as BehaviorTransition
				val senderDeploymentApp = senderBehaviorTransition.eContainer.eContainer as DeploymentApplication
				val senderDeploymentHost = senderDeploymentApp.eContainer as DeploymentHost
				val senderHostInstance = mapping.traces.findFirst[it.deploymentElements.head == senderDeploymentHost].
					cpsElements.head as HostInstance

				val appInstance = mapping.traces.findFirst[deploymentElements.head == receiverDeploymentApp].cpsElements.
					head as ApplicationInstance
				val appTypeId = appInstance.type.id
				var senderTransition = senderTrace.cpsElements.head as Transition
				val appId1 = getAppId(senderTransition.action)
				if (appTypeId == appId1 &&
					getSignalId((senderTrace.cpsElements.head as Transition).action) ==
						getSignalId((receiverTrace.cpsElements.head as Transition).action)) {

					// Only hosts has to be checked now
					if (isConnectedTo(senderHostInstance, receiverHostInstance)) {
						val sender = senderBehaviorTransition
						val receiver = receiverBehaviorTransition
						sender.trigger += receiver
					}

				}
			}
		}

		traceEnd('''setTriggerIfConnected(«receiverTrace.name»,«senderTrace.name»)''')
	}

	def isTraceForSender(CPS2DeplyomentTrace trace) {
		traceBegin('''isTraceForSender«trace.name»''')
		var isSender = false;
		var elements = trace.cpsElements
		for (t : elements) {
			isSender = isSender || (t as Transition).isTransitionSender
		}
		traceEnd('''isTraceForSender«trace.name»''')
		return isSender
	}

	def isTransitionSender(Transition transition) {
		traceBegin('''isTransitionSender(«transition.name»)''')
		if (transition.action == null) {
			return false
		}

		if (isSend(transition.action)) {
			return true
		}

		traceEnd('''isTransitionSender(«transition.name»)''')
		return false
	}

	def isTraceForReceiver(CPS2DeplyomentTrace trace) {
		traceBegin('''isTraceForReceiver(«trace.name»)''')
		var isReceiver = false;
		var elements = trace.cpsElements
		for (t : elements) {
			isReceiver = isReceiver || (t as Transition).isTransitionReceiver
		}
		traceEnd('''isTraceForReceiver(«trace.name»)''')
		return isReceiver
	}

	def isTransitionReceiver(Transition transition) {
		traceBegin('''isTransitionReceiver(«transition.name»)''')
		if (transition.action == null) {
			return false
		}

		if (isWait(transition.action)) {
			return true
		}

		traceEnd('''isTransitionReceiver(«transition.name»)''')
		return false
	}

	def isConnectedTo(HostInstance src, HostInstance dst) {
		traceBegin('''isConnectedTo(«src.name», «dst.name»)''')
		val checked = newHashSet(src)
		val reachableHosts = Lists.newArrayList(src.communicateWith)

		// Add 'src' to the initially available hosts
		reachableHosts += src
		while (!reachableHosts.empty) {

			if (reachableHosts.contains(dst)) {
				return true;
			}

			checked += reachableHosts

			// Add the transitively reachable hosts
			reachableHosts += reachableHosts.map[it.communicateWith].flatten.filter[!checked.contains(it)]

			// Remove the already checked ones
			reachableHosts -= checked
		}

		traceEnd('''isConnectedTo(«src.name», «dst.name»)''')
		return false;
	}

	def DeploymentHost transform(HostInstance hostInstance) {
		traceBegin('''transform(«hostInstance.name»)''')
		var deploymentHost = DeploymentFactory.eINSTANCE.createDeploymentHost
		deploymentHost.ip = hostInstance.nodeIp

		hostInstance.createOrAddTrace(deploymentHost)

		// Transform application instances
		val liveApplications = hostInstance.applications.filter[mapping.cps.appInstances.contains(it)]
		var deploymentApps = liveApplications.map[transform]
		deploymentHost.applications += deploymentApps

		traceEnd('''transform(«hostInstance.name»)''')
		return deploymentHost
	}

	def DeploymentApplication transform(ApplicationInstance appInstance) {
		traceBegin('''transform(«appInstance.name»)''')
		var deploymentApp = DeploymentFactory.eINSTANCE.createDeploymentApplication()
		deploymentApp.id = appInstance.id

		appInstance.createOrAddTrace(deploymentApp)

		// Transform state machines
		if (appInstance.type.behavior != null)
			deploymentApp.behavior = appInstance.type.behavior.transform

		traceEnd('''transform(«appInstance.name»)''')
		return deploymentApp
	}

	def DeploymentBehavior transform(StateMachine stateMachine) {
		traceBegin('''transform(«stateMachine.name»)''')
		val behavior = DeploymentFactory.eINSTANCE.createDeploymentBehavior
		behavior.description = stateMachine.id

		stateMachine.createOrAddTrace(behavior)

		// Transform states
		val behaviorStates = stateMachine.states.map[transform]
		behavior.states += behaviorStates

		// Transform transitions
		var behaviorTransitions = new ArrayList<BehaviorTransition>
		for (state : stateMachine.states) {
			val stateMapping = mapping.traces.findFirst[it.cpsElements.contains(state)]
			val parentBehaviorState = stateMapping.deploymentElements.head as BehaviorState
			behaviorTransitions.addAll(
				state.outgoingTransitions.filter[targetState != null].filter[transition|
					mapping.traces.findFirst[it.cpsElements.contains(transition.targetState)] != null].map[
					transform(parentBehaviorState)]
			)
		}

		behavior.transitions += behaviorTransitions

		setCurrentState(stateMachine, behavior)

		traceEnd('''transform(«stateMachine.name»)''')
		return behavior
	}

	def BehaviorState transform(State state) {
		traceBegin('''transform(«state.name»)''')
		val behaviorState = DeploymentFactory.eINSTANCE.createBehaviorState
		behaviorState.description = state.id

		state.createOrAddTrace(behaviorState)

		traceEnd('''transform(«state.name»)''')
		behaviorState
	}

	def BehaviorTransition transform(Transition transition, BehaviorState parentBehaviorState) {
		traceBegin('''transform(«transition.name», «parentBehaviorState.name»)''')

		val behaviorTransition = DeploymentFactory.eINSTANCE.createBehaviorTransition

		val targetStateMapping = mapping.traces.findFirst[it.cpsElements.contains(transition.targetState)]
		val dep = targetStateMapping.deploymentElements
		val targetBehaviorState = dep.head as BehaviorState
		behaviorTransition.to = targetBehaviorState
		parentBehaviorState.outgoing += behaviorTransition
		behaviorTransition.description = transition.id

		transition.createOrAddTrace(behaviorTransition)

		traceEnd('''transform(«transition.name», «parentBehaviorState.name»)''')
		return behaviorTransition
	}

	def setCurrentState(StateMachine stateMachine, DeploymentBehavior behavior) {
		traceBegin('''transform(«stateMachine.name», «behavior.name»)''')
		val initial = stateMachine.states.findFirst[stateMachine.initial == it]
		if (initial != null) {
			val mappingForInitialState = mapping.traces.findFirst[it.cpsElements.contains(initial)]

			val initialBehaviorState = mappingForInitialState.deploymentElements.findFirst[behavior.states.contains(it)]

			behavior.current = initialBehaviorState as BehaviorState
		}
		traceEnd('''transform(«stateMachine.name», «behavior.name»)''')
	}

	def createOrAddTrace(Identifiable identifiable, DeploymentElement deploymentElement) {
		traceBegin('''createOrAddTrace(«identifiable.name», «deploymentElement.name»)''')
		val trace = mapping.traces.filter[it.cpsElements.contains(identifiable)]
		if (trace.length <= 0) {
			identifiable.createTrace(deploymentElement)
		} else if (trace.length == 1) {
			trace.head.deploymentElements += deploymentElement
		} else {
			throw new IllegalStateException(
				'''More than one mapping was created to state machine wit Id '«identifiable.id»'.''')
		}

		traceEnd('''createOrAddTrace(«identifiable.name», «deploymentElement.name»)''')
	}

	def createTrace(Identifiable identifiable, DeploymentElement deploymentElement) {
		traceBegin('''createTrace(«identifiable.name», «deploymentElement.name»)''')

		var trace = TraceabilityFactory.eINSTANCE.createCPS2DeplyomentTrace
		trace.cpsElements += identifiable
		trace.deploymentElements += deploymentElement
		mapping.traces += trace

		traceBegin('''createTrace(«identifiable.name», «deploymentElement.name»)''')
	}

	def dispose() {
		traceBegin("dispose()")
		traceEnd("dispose()")
	}
}
