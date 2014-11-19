package org.eclipse.incquery.examples.cps.xfrom.m2m.batch.eiq

import com.google.common.base.Stopwatch
import java.util.List
import java.util.concurrent.TimeUnit
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
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xfrom.m2m.batch.eiq.queries.CpsXformM2M
import org.eclipse.incquery.runtime.api.IncQueryEngine

import static com.google.common.base.Preconditions.*

class CPS2DeploymentBatchTransformationEiq {

	extension Logger logger = Logger.getLogger("cps.xform.CPS2DeploymentTransformation")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance

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
		
		debug("Preparing queries on engine.")
		val watch = Stopwatch.createStarted
		prepare(engine)
		watch.stop
		debug('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}

	def execute() {
		clearModel

		info(
			'''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')

		val watch = Stopwatch.createStarted

		debug("Running host transformations.")
		mapping.cps.hostInstances.forEach[transform]
		debug('''Running host transformations(«watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

		watch.reset.start

		debug("Running action transformations.")
		engine.depTransition.allMatches.map[depTransition].forEach[mapAction]
		debug('''Running action transformations(«watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}

	private def transform(HostInstance cpsHost) {
		trace('''Executing: transform(cpsHost = «cpsHost»)''')
		val depHost = cpsHost.createDepHost

		debug('''Adding host («depHost.description») to deployment model.''')
		mapping.deployment.hosts += depHost
		addTrace(cpsHost, depHost)

		cpsHost.applications.filter[mapping.cps.appInstances.contains(it)].forEach [
			transform(depHost)
		]
		trace('''Execution ended: transform''')
	}

	private def transform(ApplicationInstance cpsInstance, DeploymentHost depHost) {
		trace('''Executing: transform(cpsInstance = «cpsInstance», depHost = «depHost»)''')
		val depApp = cpsInstance.createDepApplication

		depHost.applications += depApp
		addTrace(cpsInstance, depApp)

		cpsInstance.type.behavior?.transform(depApp)
		trace('''Execution ended: transform''')
	}

	private def transform(StateMachine cpsBehavior, DeploymentApplication depApp) {
		trace('''Executing: transform(cpsBehavior = «cpsBehavior», depApp = «depApp»)''')
		val depBehavior = cpsBehavior.createDepBehavior

		depApp.behavior = depBehavior
		addTraceOneToN(cpsBehavior, #[depBehavior])

		cpsBehavior.states.forEach [
			transform(depBehavior)
		]

		cpsBehavior.states.forEach [
			buildStateRelations(depBehavior, cpsBehavior)
		]

		if (cpsBehavior.initial != null)
			depBehavior.current = engine.cps2depTrace.getAllMatches(mapping, null, cpsBehavior.initial, null).map[
				depElement].head as BehaviorState
		else
			depBehavior.current = null
		trace('''Execution ended: transform''')
	}

	private def transform(State cpsState, DeploymentBehavior depBehavior) {
		trace('''Executing: transform(cpsState = «cpsState», depBehavior = «depBehavior»)''')
		val depState = cpsState.createDepState

		depBehavior.states += depState
		addTraceOneToN(cpsState, #[depState])
		trace('''Execution ended: transform''')
	}

	private def buildStateRelations(State cpsState, DeploymentBehavior depBehavior, StateMachine cpsBehavior) {
		trace(
			'''Executing: buildStateRelations(cpsState = «cpsState», depBehavior = «depBehavior», cpsBehavior = «cpsBehavior»)''')
		val depState = engine.cps2depTrace.getAllMatches(mapping, null, cpsState, null).map[depElement].head as BehaviorState
		cpsState.outgoingTransitions.filter[targetState != null && cpsBehavior.states.contains(targetState)].forEach [
			mapTransition(depState, depBehavior)
		]
		trace('''Execution ended: buildStateRelations''')
	}

	private def mapTransition(Transition transition, BehaviorState depState, DeploymentBehavior depBehavior) {
		trace(
			'''Executing: mapTransition(transition = «transition», depState = «depState», depBehavior = «depBehavior»)''')
		val depTransition = transition.createDepTransition

		depState.outgoing += depTransition
		depBehavior.transitions += depTransition
		addTraceOneToN(transition, #[depTransition])

		depTransition.to = engine.cps2depTrace.getAllMatches(mapping, null, transition.targetState, null).map[
			depElement].head as BehaviorState
		trace('''Execution ended: mapTransition''')
	}

	private def mapAction(BehaviorTransition depTrigger) {
		trace('''Executing: mapAction(depTrigger = «depTrigger»)''')
		val cpsTransition = engine.cps2depTrace.getAllMatches(mapping, null, null, depTrigger).map[cpsElement].head as Transition
		depTrigger.trigger += engine.triggerPair.getAllMatches(cpsTransition, null).map[depTarget]
		trace('''Execution ended: mapAction''')
	}

	private def createDepHost(HostInstance cpsHost) {
		trace('''Executing: createDepHost(cpsHost = «cpsHost»)''')
		val depHost = depFactory.createDeploymentHost

		depHost.ip = cpsHost.nodeIp
		trace('''Execution ended: createDepHost''')
		depHost
	}

	private def createDepApplication(ApplicationInstance cpsAppInstance) {
		trace('''Executing: createDepApplication(cpsAppInstance = «cpsAppInstance»)''')
		val depApp = depFactory.createDeploymentApplication

		depApp.id = cpsAppInstance.id
		trace('''Execution: createDepApplication''')
		depApp
	}

	private def createDepBehavior(StateMachine cpsBehavior) {
		trace('''Executing: createDepBehavior(cpsBehavior = «cpsBehavior»)''')
		val depBehavior = depFactory.createDeploymentBehavior

		depBehavior.description = cpsBehavior.id
		trace('''Execution ended: createDepBehavior''')
		depBehavior
	}

	private def createDepState(State cpsState) {
		trace('''Executing: createDepState(cpsState = «cpsState»)''')
		val depState = depFactory.createBehaviorState

		depState.description = cpsState.id
		trace('''Execution ended: createDepState''')
		depState
	}

	private def createDepTransition(Transition cpsTransition) {
		trace('''Executing: createDepTransition(cpsTransition = «cpsTransition»)''')
		val depTransition = depFactory.createBehaviorTransition

		depTransition.description = cpsTransition.id
		trace('''Execution ended: createDepTransition''')
		depTransition
	}

	private def clearModel() {
		trace('''Executing: clearModel()''')
		mapping.traces.clear
		mapping.deployment.hosts.clear
		trace('''Execution ended: clearModel''')
	}

	private def addTraceOneToN(Identifiable cpsElement, List<? extends DeploymentElement> depElements) {
		trace('''Executing: addTraceOneToN(cpsElement = «cpsElement», depElements = «depElements»)''')
		var trace = engine.cps2depTrace.getAllMatches(mapping, null, cpsElement, null).map[trace].head
		if (trace == null) {
			trace = tracFactory.createCPS2DeplyomentTrace

			trace.cpsElements += cpsElement
		}
		trace.deploymentElements += depElements

		debug('''Adding trace («cpsElement»->«depElements») to traceability model.''')
		mapping.traces += trace
		trace('''Execution ended: addTraceOneToN''')
	}

	private def addTrace(Identifiable cpsElement, DeploymentElement depElement) {
		trace('''Executing: addTrace(cpsElement = «cpsElement», depElement = «depElement»)''')
		val trace = tracFactory.createCPS2DeplyomentTrace

		trace.cpsElements += cpsElement
		trace.deploymentElements += depElement

		debug('''Adding trace («cpsElement»->«depElement») to traceability model.''')
		mapping.traces += trace
		trace('''Execution ended: addTrace''')
	}
}
