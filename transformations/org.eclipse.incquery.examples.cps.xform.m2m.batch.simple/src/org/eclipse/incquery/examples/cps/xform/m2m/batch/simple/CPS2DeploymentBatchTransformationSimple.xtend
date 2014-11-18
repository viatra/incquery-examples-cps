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

class CPS2DeploymentBatchTransformationSimple {
	
	CPSToDeployment mapping;
	
	new (CPSToDeployment mapping) {
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
		hostInstance.createTrace(deploymentHost)

		// Transform application instances
		val liveApplications = hostInstance.applications.filter[mapping.cps.appInstances.contains(it)]
		var deploymentApps = liveApplications.map[transform]
		deploymentHost.applications.addAll(deploymentApps)

		return deploymentHost
	}

	def DeploymentApplication transform(ApplicationInstance appInstance) {
		var deploymentApp = DeploymentFactory.eINSTANCE.createDeploymentApplication()
		deploymentApp.id = appInstance.id
		
		appInstance.createTrace(deploymentApp)
		
		val stateMachine = appInstance.stateMachine

		// Transform state machines
		//deploymentApp.createStateMachine(stateMachine)

		return deploymentApp
	}

	def void createStateMachine(DeploymentApplication application, StateMachine stateMachine) {
		val behavior = DeploymentFactory.eINSTANCE.createDeploymentBehavior
		application.behavior = behavior

		behavior.description = stateMachine.id

		stateMachine.createTrace(behavior)
		
	}

	def StateMachine getStateMachine(ApplicationInstance appInstance) {
		return appInstance.type.behavior;
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