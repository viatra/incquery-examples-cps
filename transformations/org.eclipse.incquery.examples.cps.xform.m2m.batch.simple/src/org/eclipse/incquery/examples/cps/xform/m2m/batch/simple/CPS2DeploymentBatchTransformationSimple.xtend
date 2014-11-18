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

class CPS2DeploymentBatchTransformationSimple {
	
	def execute(CPSToDeployment mapping) {

		// Transform host instances
		val hosts = mapping.cps.hostInstances.map[transform(mapping)]
		mapping.deployment.hosts.addAll(hosts)
	}

	def DeploymentHost transform(HostInstance hostInstance, CPSToDeployment mapping) {
		var deploymentHost = DeploymentFactory.eINSTANCE.createDeploymentHost
		deploymentHost.ip = hostInstance.nodeIp
		createTrace(hostInstance, deploymentHost, mapping)

		// Transform application instances
		var deploymentApps = hostInstance.applications.map[transform(mapping)]
		deploymentHost.applications.addAll(deploymentApps)

		return deploymentHost
	}

	def DeploymentApplication transform(ApplicationInstance appInstance, CPSToDeployment mapping) {
		var deploymentApp = DeploymentFactory.eINSTANCE.createDeploymentApplication()
		deploymentApp.id = appInstance.id

		val stateMachine = findApplicationBehavior(appInstance)

		// Transform state machines
		deploymentApp.createStateMachine(stateMachine, mapping)

		return deploymentApp
	}

	def void createStateMachine(DeploymentApplication application, StateMachine stateMachine, CPSToDeployment mapping) {
		val behavior = DeploymentFactory.eINSTANCE.createDeploymentBehavior
		application.behavior = behavior

		// Transform state machines
		stateMachine.states.map[transform(mapping)]

	}

	def BehaviorState transform(State state, CPSToDeployment mapping) {

		//val behaviorState = DeploymentFactory.eINSTANCE.createBehaviorState
		// TODO
		return null;

	}

	// TODO remove it from here
	def StateMachine findApplicationBehavior(ApplicationInstance appInstance) {
		return appInstance.type.behavior;
	}

	def createTrace(Identifiable identifiable, DeploymentElement deploymentElement, CPSToDeployment mapping) {
		var trace = TraceabilityFactory.eINSTANCE.createCPS2DeplyomentTrace
		trace.cpsElements.add(identifiable)
		trace.deploymentElements.add(deploymentElement)
		mapping.traces.add(trace)
	}

	def dispose() {
	}
}