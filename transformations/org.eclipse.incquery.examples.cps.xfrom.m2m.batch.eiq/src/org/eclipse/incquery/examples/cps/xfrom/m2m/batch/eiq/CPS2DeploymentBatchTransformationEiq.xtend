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

import static extension org.eclipse.incquery.examples.cps.xform.m2m.util.NamingUtil.*

class CPS2DeploymentBatchTransformationEiq {

	extension Logger logger = Logger.getLogger("cps.xform.m2m.batch.eiq")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance

	DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	TraceabilityFactory tracFactory = TraceabilityFactory.eINSTANCE

	CPSToDeployment mapping
	IncQueryEngine engine

	/**
	 * Initializes a new instance of the transformation using the specified
	 * model and IncQuery engine.
	 * 
	 * @param mapping
	 *            The traceability model cntaining the cps and deployment
	 *            models. The transformation will be run on this.
	 * @param engine
	 *            The IncQuery engine initialized on the mapping.
	 * 
	 * @throws IllegalArgumentException
	 *             If either of the input arguments are null, or the mapping
	 *             does not contain a cps and a deployment model.
	 */
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

	/**
     * Runs the transformation on the model the class was initialized on.
     */
	def execute() {
		clearModel

		info(
			'''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')

		debug("Running host transformations.")
		val watch = Stopwatch.createStarted
		mapping.cps.hostInstances.forEach[transform]
		debug('''Running host transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

		watch.reset.start

		debug("Running action transformations.")
		engine.depTransition.allMatches.map[depTransition].forEach[mapAction]
		debug('''Running action transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}

	/**
	 * Runs the transformation on the provided {@link HostInstance}. Creates the
	 * {@link DeploymentHost} in the deployment model and also runs the
	 * transformations of the applications.
	 * 
	 * @param cpsHost
	 *            The host to be transformed.
	 */
	private def transform(HostInstance cpsHost) {
		trace('''Executing: transform(cpsHost = «cpsHost.name»)''')
		val depHost = cpsHost.createDepHost

		debug('''Adding host («depHost.description») to deployment model.''')
		mapping.deployment.hosts += depHost
		addTrace(cpsHost, depHost)

		debug("Running application instance transformations.")
		val watch = Stopwatch.createStarted
		cpsHost.applications.filter[mapping.cps.appInstances.contains(it)].forEach [
			transform(depHost)
		]
		debug('''Running application instance transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
		trace('''Execution ended: transform''')
	}

	/**
	 * Runs the transformation on an {@link ApplicationInstance}. Creates the
	 * {@link DeploymentApplication} in the deployment model. Also creates an
	 * instance of the {@link StateMachine} referred in the
	 * {@link ApplicationType}.
	 * 
	 * @param cpsInstance
	 *            The application instance to be transformed.
	 * @param depHost
	 *            The parent which will contain the transformed application.
	 */
	private def transform(ApplicationInstance cpsInstance, DeploymentHost depHost) {
		trace('''Executing: transform(cpsInstance = «cpsInstance.name», depHost = «depHost.name»)''')
		val depApp = cpsInstance.createDepApplication

		depHost.applications += depApp
		addTrace(cpsInstance, depApp)

		debug("Running state machine transformations.")
		val watch = Stopwatch.createStarted
		cpsInstance.type.behavior?.transform(depApp)
		debug('''Running state machine transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
		trace('''Execution ended: transform''')
	}

	/**
	 * Runs the transformation of a {@link StateMachine}. Creates the
	 * {@link DeploymentBehavior} in the deployment model. Also creates the
	 * {@link BehaviorState}s and {@link BehaviorTransition}s in the transformed
	 * state machine, furthermore sets the current state in the transformed
	 * state machine to the initial state of the cps state machine.
	 * 
	 * @param cpsBehavior
	 *            The state machine to be transformed.
	 * @param depApp
	 *            The parent which will contain the transformed state machine.
	 */
	private def transform(StateMachine cpsBehavior, DeploymentApplication depApp) {
		trace('''Executing: transform(cpsBehavior = «cpsBehavior.name», depApp = «depApp.name»)''')
		val depBehavior = cpsBehavior.createDepBehavior

		depApp.behavior = depBehavior
		addTraceOneToN(cpsBehavior, #[depBehavior])

		debug("Running state transformations.")
		val watch = Stopwatch.createStarted
		cpsBehavior.states.forEach [
			transform(depBehavior)
		]
		debug('''Running state transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

		debug("Resolving state relationships.")
		watch.reset.start
		cpsBehavior.states.forEach [
			buildStateRelations(depBehavior, cpsBehavior)
		]
		debug('''Resolving state relationships («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

		debug("Resolving initial state.")
		watch.reset.start
		if (cpsBehavior.initial != null)
			depBehavior.current = engine.cps2depTrace.getAllMatches(mapping, null, cpsBehavior.initial, null).map[
				depElement].filter(BehaviorState).findFirst[depBehavior.states.contains(it)]
		else
			depBehavior.current = null
		debug('''Resolving initial state («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
		trace('''Execution ended: transform''')
	}

	/**
	 * Runs the transformation of a {@link State}. Creates the
	 * {@link BehaviorState} in the deployment model.
	 * 
	 * @param cpsState
	 *            The state to be transformed.
	 * @param depBehavior
	 *            The parent which will contain the transformed state.
	 */
	private def transform(State cpsState, DeploymentBehavior depBehavior) {
		trace('''Executing: transform(cpsState = «cpsState.name», depBehavior = «depBehavior.name»)''')
		val depState = cpsState.createDepState

		depBehavior.states += depState
		addTraceOneToN(cpsState, #[depState])
		trace('''Execution ended: transform''')
	}

	/**
	 * Builds the relationships between {@link BehaviorState}s. For each
	 * {@link Transition} in a {@link State} it sets the corresponding
	 * {@link BehaviorTransition}s to property to the proper
	 * {@link BehaviorTransition}.
	 * 
	 * @param cpsState
	 *            The state witches relation will be built.
	 * @param depBehavior
	 *            The state from cps model.
	 * @param cpsBehavior
	 *            The state from the deployment model.
	 */
	private def buildStateRelations(State cpsState, DeploymentBehavior depBehavior, StateMachine cpsBehavior) {
		trace(
			'''Executing: buildStateRelations(cpsState = «cpsState.name», depBehavior = «depBehavior.name», cpsBehavior = «cpsBehavior.
				name»)''')
		val depState = engine.cps2depTrace.getAllMatches(mapping, null, cpsState, null).map[depElement].filter(
			BehaviorState).findFirst[depBehavior.states.contains(it)]
		cpsState.outgoingTransitions.filter[targetState != null && cpsBehavior.states.contains(targetState)].forEach [
			mapTransition(depState, depBehavior)
		]
		trace('''Execution ended: buildStateRelations''')
	}

	private def mapTransition(Transition transition, BehaviorState depState, DeploymentBehavior depBehavior) {
		trace(
			'''Executing: mapTransition(transition = «transition.name», depState = «depState.name», depBehavior = «depBehavior.
				name»)''')
		val depTransition = transition.createDepTransition

		depState.outgoing += depTransition
		depBehavior.transitions += depTransition
		addTraceOneToN(transition, #[depTransition])

		depTransition.to = engine.cps2depTrace.getAllMatches(mapping, null, transition.targetState, null).map[
			depElement].head as BehaviorState
		trace('''Execution ended: mapTransition''')
	}

	private def mapAction(BehaviorTransition depTrigger) {
		trace('''Executing: mapAction(depTrigger = «depTrigger.name»)''')
		val cpsTransition = engine.cps2depTrace.getAllMatches(mapping, null, null, depTrigger).map[cpsElement].head as Transition
		depTrigger.trigger += engine.triggerPair.getAllMatches(cpsTransition, null).map[depTarget]
		trace('''Execution ended: mapAction''')
	}

	private def createDepHost(HostInstance cpsHost) {
		trace('''Executing: createDepHost(cpsHost = «cpsHost.name»)''')
		val depHost = depFactory.createDeploymentHost

		depHost.ip = cpsHost.nodeIp
		trace('''Execution ended: createDepHost''')
		depHost
	}

	private def createDepApplication(ApplicationInstance cpsAppInstance) {
		trace('''Executing: createDepApplication(cpsAppInstance = «cpsAppInstance.name»)''')
		val depApp = depFactory.createDeploymentApplication

		depApp.id = cpsAppInstance.id
		trace('''Execution: createDepApplication''')
		depApp
	}

	private def createDepBehavior(StateMachine cpsBehavior) {
		trace('''Executing: createDepBehavior(cpsBehavior = «cpsBehavior.name»)''')
		val depBehavior = depFactory.createDeploymentBehavior

		depBehavior.description = cpsBehavior.id
		trace('''Execution ended: createDepBehavior''')
		depBehavior
	}

	private def createDepState(State cpsState) {
		trace('''Executing: createDepState(cpsState = «cpsState.name»)''')
		val depState = depFactory.createBehaviorState

		depState.description = cpsState.id
		trace('''Execution ended: createDepState''')
		depState
	}

	private def createDepTransition(Transition cpsTransition) {
		trace('''Executing: createDepTransition(cpsTransition = «cpsTransition.name»)''')
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
		trace(
			'''Executing: addTraceOneToN(cpsElement = «cpsElement.name», depElements = [«FOR e : depElements SEPARATOR ", "»«e.
				name»«ENDFOR»])''')
		var trace = engine.cps2depTrace.getAllMatches(mapping, null, cpsElement, null).map[trace].head
		if (trace == null) {
			trace = tracFactory.createCPS2DeplyomentTrace

			trace.cpsElements += cpsElement
		}
		trace.deploymentElements += depElements

		debug(
			'''Adding trace («cpsElement.name»->[«FOR e : depElements SEPARATOR ", "»«e.name»«ENDFOR»]) to traceability model.''')
		mapping.traces += trace
		trace('''Execution ended: addTraceOneToN''')
	}

	private def addTrace(Identifiable cpsElement, DeploymentElement depElement) {
		trace('''Executing: addTrace(cpsElement = «cpsElement.name», depElement = «depElement.name»)''')
		val trace = tracFactory.createCPS2DeplyomentTrace

		trace.cpsElements += cpsElement
		trace.deploymentElements += depElement

		debug('''Adding trace («cpsElement.name»->«depElement.name») to traceability model.''')
		mapping.traces += trace
		trace('''Execution ended: addTrace''')
	}
}
