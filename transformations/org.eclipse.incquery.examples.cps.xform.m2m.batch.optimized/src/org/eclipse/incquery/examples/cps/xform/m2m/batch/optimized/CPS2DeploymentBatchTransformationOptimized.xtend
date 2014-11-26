package org.eclipse.incquery.examples.cps.xform.m2m.batch.optimized

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import java.util.ArrayList
import java.util.Map
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
import static org.eclipse.incquery.examples.cps.xform.m2m.util.SignalUtil.*

import static extension org.eclipse.incquery.examples.cps.xform.m2m.util.NamingUtil.*

class CPS2DeploymentBatchTransformationOptimized {

	extension Logger logger = Logger.getLogger("cps.xform.m2m.batch.optimized")

	private def traceBegin(String method) {
		trace('''Executing «method» BEGIN''')
	}

	private def traceEnd(String method) {
		trace('''Executing «method» END''')
	}

	CPSToDeployment mapping;

	/**
	 * Creates a new transformation instance. The input cyber physical system model is given in the mapping
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

		info(
			'''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')
		
		
		mapping.traces.clear
		mapping.deployment.hosts.clear

		// Transform host instances
		val hosts = mapping.cps.hostInstances
		val deploymentHosts = ImmutableList.copyOf(hosts.map[transform])
		mapping.deployment.hosts += deploymentHosts

		mapping.traces.filter[cpsElements.head instanceof Transition].forEach[createTransitionCache]

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
		senderTransitionMappings.forEach[findAndAssignReceivers]

		traceEnd("assignTriggers()")
	}

	/**
	 * After finding the traces that contains the corresponding transitions, finds and assigns 
	 * triggered behavior transition
	 * @param senderTrace the trace that contains the sender transition
	 */
	private def findAndAssignReceivers(CPS2DeplyomentTrace senderTrace) {
		traceBegin('''findReceivers(«senderTrace.name»)''')

		var receiverTraces = mapping.traces.filter[deploymentElements.head instanceof BehaviorTransition]
		receiverTraces.forEach[setTriggerIfConnected(senderTrace)]

		traceEnd('''findReceivers(«senderTrace.name»)''')
	}

	private val transitionToAppId = Maps.newHashMap
	private val transitionToActionId = Maps.newHashMap
	private Map<BehaviorTransition, HostInstance> transitionToHost = Maps.newHashMap

	private def void createTransitionCache(CPS2DeplyomentTrace transitionTrace){
		val transition = transitionTrace.cpsElements.head as Transition
		if(transition.action == null){
			return
		}
		val actionId = getSignalId(transition.action)
		for (i : transitionTrace.deploymentElements) {
			val behaviorTransition = i as BehaviorTransition
			val deploymentApp = behaviorTransition.eContainer.eContainer as DeploymentApplication
			val deploymentHost = deploymentApp.eContainer as DeploymentHost
			val hostInstance = mapping.traces.findFirst[it.deploymentElements.head == deploymentHost]
				.cpsElements.head as HostInstance
			val appInstance = mapping.traces.findFirst[deploymentElements.head == deploymentApp]
				.cpsElements.head as ApplicationInstance
			val appTypeId = appInstance.type.id
			
			transitionToAppId.put(behaviorTransition,appTypeId)
			transitionToActionId.put(behaviorTransition,actionId)
			transitionToHost.put(behaviorTransition,hostInstance)
		}
	}

	/**
	 * Sets the trigger reference for the sender behavior transition if 
	 * <li> the transition is waiting for the same type of message as the sender sends and
	 * <li> the receiving transition is in a deployed application that runs on a reachable host
	 * 
	 * @param senderTrace the trace that contains the sender transition
	 * @param receiverTrace the trace that contains the receiver transition
	 */
	private def void setTriggerIfConnected(CPS2DeplyomentTrace receiverTrace, CPS2DeplyomentTrace senderTrace) {
		traceBegin('''setTriggerIfConnected(«receiverTrace.name»,«senderTrace.name»)''')

		if (!isTraceForReceiver(receiverTrace))
			return;

		val senderReceiverMappings = Maps.newHashMap
		
		for(sender : receiverTrace.deploymentElements){
			senderReceiverMappings.put(sender as BehaviorTransition,receiverTrace.deploymentElements)
		}
		
		// a trace here refers to BehaviorTransitions
		for (i : receiverTrace.deploymentElements) {
			val receiverBehaviorTransition = i as BehaviorTransition
			
			val appTypeId = transitionToAppId.get(receiverBehaviorTransition)
			var senderTransition = senderTrace.cpsElements.head as Transition
			val targetAppId = getAppId(senderTransition.action)
			val receiverHostInstance = transitionToHost.get(receiverBehaviorTransition)
			
			transitionToActionId.get(receiverBehaviorTransition)
			val receiverSignalId = transitionToActionId.get(receiverBehaviorTransition)
			
			
			for (j : senderTrace.deploymentElements) {

				val senderBehaviorTransition = j as BehaviorTransition
				val senderSignalId = transitionToActionId.get(senderBehaviorTransition)
				val senderHostInstance = transitionToHost.get(senderBehaviorTransition)

				if (appTypeId == targetAppId && receiverSignalId == senderSignalId ) {

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

	/**
	 * Returns if a trace contains a transition that sends a message
	 * @param trace the trace that links transitions and behavior transitions
	 */
	private def isTraceForSender(CPS2DeplyomentTrace trace) {
		traceBegin('''isTraceForSender«trace.name»''')
		var isSender = false;
		var elements = trace.cpsElements
		for (t : elements) {
			isSender = isSender || (t as Transition).isTransitionSender
		}
		traceEnd('''isTraceForSender«trace.name»''')
		return isSender
	}

	/**
	 * Returns if a transition sends a message
	 * @param transition the transitions whose action is inspected
	 */
	private def isTransitionSender(Transition transition) {
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

	/**
	 * Returns if a trace contains a transition that waits for a message
	 * @param trace the trace that links transitions and behavior transitions
	 */
	private def isTraceForReceiver(CPS2DeplyomentTrace trace) {
		traceBegin('''isTraceForReceiver(«trace.name»)''')
		var isReceiver = false;
		var elements = trace.cpsElements
		for (t : elements) {
			isReceiver = isReceiver || (t as Transition).isTransitionReceiver
		}
		traceEnd('''isTraceForReceiver(«trace.name»)''')
		return isReceiver
	}

	/**
	 * Returns if a transition waits for a message
	 * @param transition the transitions whose action is inspected
	 */
	private def isTransitionReceiver(Transition transition) {
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

	/**
	 * Checks whether the two given hosts are connected via the communicatesWith relation. 
	 * Also checks transitive communication capability. The communicatesWith relation is non-reflexive by default
	 * @param src the source host
	 * @param dst the target host
	 */
	private def isConnectedTo(HostInstance src, HostInstance dst) {
		traceBegin('''isConnectedTo(«src.name», «dst.name»)''')
		val checked = newHashSet(src)
		var depth = 0 as int
		var nextHostIndex = 0 as int
		val indices = Lists.newArrayList
		indices.add(0 as int) // padding
		indices.add(0 as int) // initial next index
		val parents = Maps.newHashMap()
		parents.put(1, src);

		var currentHost = src
		while (depth >= 0) {
			if (currentHost.equals(dst)) {
				traceEnd('''isConnectedTo(«src.name», «dst.name»)''')
				return true
			} else {
				nextHostIndex = indices.get(depth + 1)
				if (nextHostIndex >= currentHost.communicateWith.length) {
					// Current host traversed, go up one level
					depth--
				} else {
					checked += currentHost

					// get the next element
					var nextHost = currentHost.communicateWith.get(nextHostIndex)

					if (checked.contains(nextHost)) {
						nextHostIndex += 1
						while (nextHostIndex < currentHost.communicateWith.length && checked.contains(nextHost)) {
							nextHost = currentHost.communicateWith.get(nextHostIndex)
							nextHostIndex += 1
						}				
						indices.set(depth + 1,nextHostIndex)
					}
					if(nextHostIndex < currentHost.communicateWith.length ){
				
						if (indices.length <= depth + 1) {
							indices.add(nextHostIndex);
						} else {
							indices.set(depth, nextHostIndex);
						}
	
						parents.put(depth, currentHost)
						currentHost = nextHost
					}

				}
			}
		}

		traceEnd('''isConnectedTo(«src.name», «dst.name»)''')
		return false;
	}

	/**
	 * Transforms a host instance to a deployment host. Sets deployment description to host ID. 
	 * @param hostInstance the host instance to transform
	 */
	private def DeploymentHost transform(HostInstance hostInstance) {
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

	/**
	 * Transforms an application instance to a deployment application. Sets deployment application description to application instance ID.
	 * @param appInstance the application instance to transform
	 */
	private def DeploymentApplication transform(ApplicationInstance appInstance) {
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

	/**
	 * Transforms a given state machine to a deployment behavior. Sets deployment behavior description to state machine ID.
	 * @param stateMachine the state machine to transform
	 */
	private def DeploymentBehavior transform(StateMachine stateMachine) {
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

	/**
	 * Transforms a state to behavior state. Sets behavior state to state id.
	 * @param state the state to transform
	 */
	private def BehaviorState transform(State state) {
		traceBegin('''transform(«state.name»)''')
		val behaviorState = DeploymentFactory.eINSTANCE.createBehaviorState
		behaviorState.description = state.id

		state.createOrAddTrace(behaviorState)

		traceEnd('''transform(«state.name»)''')
		behaviorState
	}

	/**
	 * Transforms a transition to behavior transition. 
	 * @param transition the transition to transofrm
	 * @param behaviorState the state that shall be set as the origin of the transformed behavior transition 
	 */
	private def BehaviorTransition transform(Transition transition, BehaviorState behaviorState) {
		traceBegin('''transform(«transition.name», «behaviorState.name»)''')

		val behaviorTransition = DeploymentFactory.eINSTANCE.createBehaviorTransition

		val targetStateMapping = mapping.traces.findFirst[it.cpsElements.contains(transition.targetState)]
		val dep = targetStateMapping.deploymentElements
		val targetBehaviorState = dep.head as BehaviorState
		behaviorTransition.to = targetBehaviorState
		behaviorState.outgoing += behaviorTransition
		behaviorTransition.description = transition.id

		transition.createOrAddTrace(behaviorTransition)

		traceEnd('''transform(«transition.name», «behaviorState.name»)''')
		return behaviorTransition
	}

	/**
	 * Sets the value of the current state based on the state machine
	 * @param stateMachine the state machine that describes the behavior
	 * @param behavior realizes the state machine in the target model
	 */
	private def setCurrentState(StateMachine stateMachine, DeploymentBehavior behavior) {
		traceBegin('''transform(«stateMachine.name», «behavior.name»)''')
		val initial = stateMachine.states.findFirst[stateMachine.initial == it]
		if (initial != null) {
			val mappingForInitialState = mapping.traces.findFirst[it.cpsElements.contains(initial)]

			val initialBehaviorState = mappingForInitialState.deploymentElements.findFirst[behavior.states.contains(it)]

			behavior.current = initialBehaviorState as BehaviorState
		}
		traceEnd('''transform(«stateMachine.name», «behavior.name»)''')
	}

	/**
	 * Creates or adds trace between the given identifiable and deployment element. It also stores the created trace in the traceability model
	 * @param identifiable the left hand side of the mapping 
	 * @param deploymentElement the right hand side of the mapping 
	 */
	private def createOrAddTrace(Identifiable identifiable, DeploymentElement deploymentElement) {
		traceBegin('''createOrAddTrace(«identifiable.name», «deploymentElement.name»)''')
		val trace = mapping.traces.filter[it.cpsElements.contains(identifiable)]
		if (trace.empty) {
			return identifiable.createTrace(deploymentElement)
		} else {
			trace.head.deploymentElements += deploymentElement
			if(!trace.tail.empty){
				throw new IllegalStateException(
					'''More than one mapping was created to state machine wit Id '«identifiable.id»'.''')
			}
		}

		traceEnd('''createOrAddTrace(«identifiable.name», «deploymentElement.name»)''')
		return trace.head
	}

	/** Creates trace between the given identifiable and deployment element. It also stores the created trace in the traceability model
	 * @param identifiable the left hand side of the mapping 
	 * @param deploymentElement the right hand side of the mapping 
	 */
	private def createTrace(Identifiable identifiable, DeploymentElement deploymentElement) {
		traceBegin('''createTrace(«identifiable.name», «deploymentElement.name»)''')

		var trace = TraceabilityFactory.eINSTANCE.createCPS2DeplyomentTrace
		trace.cpsElements += identifiable
		trace.deploymentElements += deploymentElement
		mapping.traces += trace

		traceBegin('''createTrace(«identifiable.name», «deploymentElement.name»)''')
		return trace
	}

	/**
	 * Cleans up the transformation
	 */
	def dispose() {
		traceBegin("dispose()")
		traceEnd("dispose()")
	}
}
