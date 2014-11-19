package org.eclipse.incquery.examples.cps.xfrom.m2m.batch.eiq

import java.util.List
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xfrom.m2m.batch.eiq.queries.CpsXformM2M
import org.eclipse.incquery.runtime.api.IncQueryEngine

import static com.google.common.base.Preconditions.*

class CPS2DeploymentBatchTransformationEiq {

	extension Logger logger = Logger.getLogger("cps.xform.CPS2DeploymentTransformation")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance

	CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	TraceabilityFactory tracFactory = TraceabilityFactory.eINSTANCE

	CPSToDeployment mapping
	IncQueryEngine engine

	new(CPSToDeployment mapping, IncQueryEngine engine) {
		checkArgument(mapping != null, "Mapping cannot be null!")
		checkArgument(mapping.cps != null, "CPS not defined in mapping!")
		checkArgument(mapping.deployment != null, "Deployment not defined in mapping!")
		checkArgument(engine != null, "Engine cannot be null!")

		this.mapping = mapping
		this.engine = engine
	}

	def execute() {
		clearModel

		info(
			'''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')

		mapping.cps.hostInstances.forEach[transform]

		mapping.cps.appInstances.filter[allocatedTo != null && mapping.cps.hostInstances.contains(allocatedTo)].forEach[
			transform]
	}

	private def transform(HostInstance cpsHost) {
		val depHost = createDepHost(cpsHost)
		mapping.deployment.hosts += depHost
		addTrace(cpsHost, depHost)
	}

	private def transform(ApplicationInstance cpsInstance) {
		val depHost = getDepHost(cpsInstance)
		val depApp = createDepApplication(cpsInstance)
		depHost.applications += depApp
		addTrace(cpsInstance, depApp)
		cpsInstance.type.behavior.transform(depApp)
	}

	private def transform(StateMachine cpsBehavior, DeploymentApplication depApp) {
		if (cpsBehavior != null) {
			val depBehavior = createDepBehavior(cpsBehavior)
			addTraceOneToN(cpsBehavior, #[depBehavior])
			cpsBehavior.states.forEach [
				val depState = createDepState
				depBehavior.states += depState
				addTraceOneToN(it, #[depState])
			]
			cpsBehavior.states.forEach [
				buildStateRelations(depBehavior)
			]
			if (cpsBehavior.initial != null)
				depBehavior.current = getCps2depTrace(engine).getAllMatches(mapping, null, cpsBehavior.initial, null).
					map[depElement].head as BehaviorState
			else
				depBehavior.current = null
			depApp.behavior = depBehavior
		}
	}

	private def buildStateRelations(State cpsState, DeploymentBehavior depBehavior) {
		val depState = getCps2depTrace(engine).getAllMatches(mapping, null, cpsState, null).map[depElement].head as BehaviorState
		cpsState.outgoingTransitions.forEach [
			val depTransition = createDepTransition
			depState.outgoing += depTransition
			depBehavior.transitions += depTransition
			addTraceOneToN(it, #[depTransition])
			depTransition.to = getCps2depTrace(engine).getAllMatches(mapping, null, it.targetState, null).map[
				depElement].head as BehaviorState
		]
	}

	private def createDepState(State cpsState) {
		val depState = depFactory.createBehaviorState

		depState.description = cpsState.id
		depState
	}

	private def createDepTransition(Transition cpsTransition) {
		val depTransition = depFactory.createBehaviorTransition

		depTransition.description = cpsTransition.id
		depTransition
	}

	def createDepBehavior(StateMachine cpsBehavior) {
		val depBehavior = depFactory.createDeploymentBehavior

		depBehavior.description = cpsBehavior.id
		depBehavior
	}

	def clearModel() {
		mapping.traces.clear
		mapping.deployment.hosts.clear
	}

	private def addTraceOneToN(Identifiable cpsElement, List<? extends DeploymentElement> depElements) {
		var trace = getCps2depTrace(engine).getAllMatches(mapping, null, cpsElement, null).map[trace].head
		if (trace == null) {
			trace = tracFactory.createCPS2DeplyomentTrace

			trace.cpsElements += cpsElement
		}

		trace.deploymentElements += depElements
		mapping.traces += trace
	}

	private def addTrace(Identifiable cpsElement, DeploymentElement depElement) {
		val trace = tracFactory.createCPS2DeplyomentTrace

		trace.cpsElements += cpsElement
		trace.deploymentElements += depElement

		mapping.traces += trace
	}

	private def getDepHost(ApplicationInstance cpsAppInstance) {
		val matcher = getMappedHostInstance(engine)
		val match = matcher.getAllMatches(cpsAppInstance.allocatedTo, null)
		match.head.depHost
	}

	private def createDepHost(HostInstance cpsHost) {
		val depHost = depFactory.createDeploymentHost

		depHost.ip = cpsHost.nodeIp
		depHost
	}

	private def createDepApplication(ApplicationInstance cpsAppInstance) {
		val depApp = depFactory.createDeploymentApplication

		depApp.id = cpsAppInstance.id
		depApp
	}
}
