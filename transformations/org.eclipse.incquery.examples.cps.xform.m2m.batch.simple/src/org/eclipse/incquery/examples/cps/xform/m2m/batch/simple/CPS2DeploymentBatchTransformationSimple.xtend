package org.eclipse.incquery.examples.cps.xform.m2m.batch.simple

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory

import static com.google.common.base.Preconditions.*
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior

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
		val deploymentHosts = hosts.map[transform]
		mapping.deployment.hosts.addAll(deploymentHosts)
	}

	def DeploymentHost transform(HostInstance hostInstance) {
		var deploymentHost = DeploymentFactory.eINSTANCE.createDeploymentHost
		deploymentHost.ip = hostInstance.nodeIp

		hostInstance.createOrAddTrace(deploymentHost)

		// Transform application instances
		val liveApplications = hostInstance.applications.filter[mapping.cps.appInstances.contains(it)]
		var deploymentApps = liveApplications.map[transform]
		deploymentHost.applications.addAll(deploymentApps)

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
		behavior.states.addAll(behaviorStates)

		val initials = stateMachine.states.filter[stateMachine.initial == it]
		if(initials.length > 0){
			val mappingForInitialState = mapping.traces.filter[it.cpsElements.contains(initials.get(0))].get(0)
			// TODO check for null
			val initialBehaviorState = mappingForInitialState.deploymentElements.get(0)
			
			behavior.current = initialBehaviorState as BehaviorState
		}

		return behavior
	}

	def BehaviorState transform(State state) {
		val behaviorState = DeploymentFactory.eINSTANCE.createBehaviorState
		behaviorState.description = state.id

		state.createOrAddTrace(behaviorState)

		behaviorState
	}

	def StateMachine getStateMachine(ApplicationInstance appInstance) {
		return appInstance.type.behavior;
	}

	def createOrAddTrace(Identifiable i, DeploymentElement e) {
		val trace = mapping.traces.filter[it.cpsElements.contains(i)]
		if (trace.length <= 0) {
			i.createTrace(e)
		} else if (trace.length == 1) {
			trace.get(0).deploymentElements.add(e)
		} else {
			throw new IllegalStateException(
				'''More than one mapping was created to state machine wit Id '«i.id»'.''')
		}

	}

	def createTrace(Identifiable identifiable, DeploymentElement deploymentElement) {
		var trace = TraceabilityFactory.eINSTANCE.createCPS2DeplyomentTrace
		trace.cpsElements.add(identifiable)
		trace.deploymentElements.add(deploymentElement)
		mapping.traces.add(trace)
	}

	def dispose() {
	}
}
