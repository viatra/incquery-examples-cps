package org.eclipse.incquery.examples.cps.xform.m2m.batch.simple

import com.google.common.collect.ImmutableList
import java.util.ArrayList
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
import static org.eclipse.incquery.examples.cps.xform.m2m.util.SignalUtil.*
import com.google.common.collect.Lists
import java.util.Collections

class CPS2DeploymentBatchTransformationSimple {

	CPSToDeployment mapping;

	new(CPSToDeployment mapping) {
		checkNotNull(mapping != null, "Mapping cannot be null!")
		checkArgument(mapping.cps != null, "CPS not defined in mapping!")
		checkArgument(mapping.deployment != null, "Deployment not defined in mapping!")

		this.mapping = mapping;
	}

	def execute() {
		mapping.traces.clear
		mapping.deployment.hosts.clear
		
		// Transform host instances
		val hosts = mapping.cps.hostInstances
		val deploymentHosts = ImmutableList.copyOf(hosts.map[transform])
		mapping.deployment.hosts += deploymentHosts

		assignTriggers
	}

	def assignTriggers() {

		val transitionMappings = mapping.traces.filter[deploymentElements.head instanceof BehaviorTransition]
		val senderTransitionMappings = transitionMappings.filter[isTraceForSender]
		senderTransitionMappings.forEach[findReceivers]

	}

	def findReceivers(CPS2DeplyomentTrace senderTransitonTrace) {
		var transition = senderTransitonTrace.cpsElements.head as Transition
		val appId = getAppId(transition.action)
		var receiverTraces = mapping.traces.filter[deploymentElements.head instanceof BehaviorTransition] //.filter[isTraceForReceiver]

		//var correspondingTraces = receiverTraces.filter[getAppId((cpsElements.head as Transition).action) == appId]
		//correspondingTraces.forEach[setTriggerIfConnected(senderTransitonTrace)]
		receiverTraces.forEach[setTriggerIfConnected(senderTransitonTrace)]
	}

	def void setTriggerIfConnected(CPS2DeplyomentTrace receiverTrace, CPS2DeplyomentTrace senderTrace) {

		if (!isTraceForReceiver(receiverTrace))
			return;

		// a trace here refers to BehaviorTransitions
		for (i : receiverTrace.deploymentElements) {
			for (j : senderTrace.deploymentElements) {
				val receiverBehaviorTransition = i as BehaviorTransition
				val receiverDeploymentApp = receiverBehaviorTransition.eContainer.eContainer as DeploymentApplication
				val receiverDeploymentHost = receiverDeploymentApp.eContainer as DeploymentHost
				val receiverHostInstance = mapping.traces.findFirst[it.deploymentElements.head == receiverDeploymentHost].cpsElements.head as HostInstance
	
				val senderBehaviorTransition = j as BehaviorTransition
				val senderDeploymentApp = senderBehaviorTransition.eContainer.eContainer as DeploymentApplication
				val senderDeploymentHost = senderDeploymentApp.eContainer as DeploymentHost
				val senderHostInstance = mapping.traces.findFirst[it.deploymentElements.head == senderDeploymentHost].cpsElements.head as HostInstance
	
				val appInstance = mapping.traces.findFirst[deploymentElements.head == receiverDeploymentApp].cpsElements.head as ApplicationInstance
				val appTypeId = appInstance.type.id
				var senderTransition = senderTrace.cpsElements.head as Transition
				val appId1 = getAppId(senderTransition.action)
				if (appTypeId == appId1 && getSignalId((senderTrace.cpsElements.head as Transition).action) == getSignalId((receiverTrace.cpsElements.head as Transition).action)) {
	
					// Only hosts has to be checked now
					if (isConnectedTo(senderHostInstance, receiverHostInstance)) {
						val sender = senderBehaviorTransition
						val receiver = receiverBehaviorTransition
						sender.trigger += receiver
					}
	
				}
			}
		}

	}

	def isTraceForSender(CPS2DeplyomentTrace trace) {
		var isSender = false;
		var elements = trace.cpsElements
		for (t : elements) {
			isSender = isSender || (t as Transition).isTransitionSender
		}
		return isSender
	}

	def isTransitionSender(Transition transition) {
		if (transition.action == null) {
			return false
		}

		if (isSend(transition.action)) {
			return true
		}

		return false
	}

	def isTraceForReceiver(CPS2DeplyomentTrace trace) {
		var isReceiver = false;
		var elements = trace.cpsElements
		for (t : elements) {
			isReceiver = isReceiver || (t as Transition).isTransitionReceiver
		}
		return isReceiver
	}

	def isTransitionReceiver(Transition transition) {
		if (transition.action == null) {
			return false
		}

		if (isWait(transition.action)) {
			return true
		}

		return false
	}

	def isConnectedTo(HostInstance src, HostInstance dst) {
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

		return false;

	}

	def DeploymentHost transform(HostInstance hostInstance) {
		var deploymentHost = DeploymentFactory.eINSTANCE.createDeploymentHost
		deploymentHost.ip = hostInstance.nodeIp

		hostInstance.createOrAddTrace(deploymentHost)

		// Transform application instances
		val liveApplications = hostInstance.applications.filter[mapping.cps.appInstances.contains(it)]
		var deploymentApps = liveApplications.map[transform]
		deploymentHost.applications += deploymentApps

		return deploymentHost
	}

	def DeploymentApplication transform(ApplicationInstance appInstance) {
		var deploymentApp = DeploymentFactory.eINSTANCE.createDeploymentApplication()
		deploymentApp.id = appInstance.id

		appInstance.createOrAddTrace(deploymentApp)

		// Transform state machines
		if (appInstance.stateMachine != null)
			deploymentApp.behavior = appInstance.stateMachine.transform

		return deploymentApp
	}

	def DeploymentBehavior transform(StateMachine stateMachine) {
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

		return behavior
	}

	def BehaviorState transform(State state) {
		val behaviorState = DeploymentFactory.eINSTANCE.createBehaviorState
		behaviorState.description = state.id

		state.createOrAddTrace(behaviorState)

		behaviorState
	}

	def BehaviorTransition transform(Transition transition, BehaviorState parentBehaviorState) {

		val behaviorTransition = DeploymentFactory.eINSTANCE.createBehaviorTransition

		val targetStateMapping = mapping.traces.findFirst[it.cpsElements.contains(transition.targetState)]
		val dep = targetStateMapping.deploymentElements
		val targetBehaviorState = dep.head as BehaviorState
		behaviorTransition.to = targetBehaviorState
		parentBehaviorState.outgoing += behaviorTransition
		behaviorTransition.description = transition.id

		transition.createOrAddTrace(behaviorTransition)

		return behaviorTransition
	}

	def setCurrentState(StateMachine stateMachine, DeploymentBehavior behavior) {
		val initials = stateMachine.states.filter[stateMachine.initial == it]
		if (initials.length > 0) {
			val mappingForInitialState = mapping.traces.filter[it.cpsElements.contains(initials.head)].head

			val initialBehaviorState = mappingForInitialState.deploymentElements.head

			behavior.current = initialBehaviorState as BehaviorState
		}
	}

	def StateMachine getStateMachine(ApplicationInstance appInstance) {
		return appInstance.type.behavior;
	}

	def createOrAddTrace(Identifiable i, DeploymentElement e) {
		val trace = mapping.traces.filter[it.cpsElements.contains(i)]
		if (trace.length <= 0) {
			i.createTrace(e)
		} else if (trace.length == 1) {
			trace.head.deploymentElements += e
		} else {
			throw new IllegalStateException(
				'''More than one mapping was created to state machine wit Id '«i.id»'.''')
		}

	}

	def createTrace(Identifiable identifiable, DeploymentElement deploymentElement) {
		var trace = TraceabilityFactory.eINSTANCE.createCPS2DeplyomentTrace
		trace.cpsElements += identifiable
		trace.deploymentElements += deploymentElement
		mapping.traces += trace
	}

	def dispose() {
	}
}
