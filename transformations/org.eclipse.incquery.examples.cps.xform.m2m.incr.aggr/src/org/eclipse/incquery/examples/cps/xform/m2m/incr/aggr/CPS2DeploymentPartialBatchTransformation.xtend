package org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr

import com.google.common.base.Stopwatch
import com.google.common.collect.ArrayListMultimap
import com.google.common.collect.HashBasedTable
import com.google.common.collect.Maps
import com.google.common.collect.Multimap
import com.google.common.collect.Table
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
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
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.util.AppInstancesQuerySpecification
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.util.AppTypesQuerySpecification
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.util.StateMachinesQuerySpecification
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.util.StatesQuerySpecification
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.util.TransitionsQuerySpecification
import org.eclipse.incquery.examples.cps.xform.m2m.util.SignalUtil
import org.eclipse.incquery.examples.cps.xform.m2t.util.genericmonitor.ChangeDelta
import org.eclipse.incquery.examples.cps.xform.m2t.util.genericmonitor.ChangeMonitor
import org.eclipse.incquery.runtime.api.IPatternMatch
import org.eclipse.incquery.runtime.api.IQuerySpecification
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.api.IncQueryMatcher

import static com.google.common.base.Preconditions.*

import static extension org.eclipse.incquery.examples.cps.xform.m2m.util.NamingUtil.*
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.queries.util.HostInstancesQuerySpecification

class CPS2DeploymentPartialBatchTransformation {

	extension Logger logger = Logger.getLogger("cps.xform.m2m.incr.aggr")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance

	DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	TraceabilityFactory tracFactory = TraceabilityFactory.eINSTANCE

	CPSToDeployment mapping
	IncQueryEngine engine
	ChangeMonitor monitor;

	Stopwatch clearModelPerformance;
	Stopwatch hostTransformationPerformance;
	Stopwatch appTransformationPerformance;
	Stopwatch stateMachineTransformationPerformance;
	Stopwatch stateTransformationPerformance;
	Stopwatch transitionTransformationPerformance;
	Stopwatch triggerTransformationPerformance;

	Stopwatch otherTimer

	Table<State, DeploymentBehavior, BehaviorState> stateTable
	Map<Identifiable, CPS2DeplyomentTrace> traceTable
	Map<Transition, String> transitionMap

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
		transitionMap = new HashMap
		engine.transitions.allMatches.forEach[m|transitionMap.put(m.transition, m.transition.action)]

		monitor = new ChangeMonitor(engine);

		monitor.addRule(HostInstancesQuerySpecification.instance)
		monitor.addRule(AppTypesQuerySpecification.instance)
		monitor.addRule(AppInstancesQuerySpecification.instance)
		monitor.addRule(StateMachinesQuerySpecification.instance)
		monitor.addRule(StatesQuerySpecification.instance)
		monitor.addRule(TransitionsQuerySpecification.instance);
		monitor.startMonitoring

		watch.stop
		info('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}

	/**
     * Runs the transformation on the model the class was initialized on.
     */
	def execute() {
		initPerformanceTimers()
		val delta = monitor.createCheckpoint
		
		delta.appeared.keySet.forEach [ spec |
			delta.appeared.get(spec).forEach [ b |
				if (b instanceof Transition) {
					val transition = b as Transition
					transitionMap.put(transition, transition.action)

				}
			]
		]

		clearModelPerformance.start
		delta.clearModel
		clearModelPerformance.stop

		info(
			'''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')

		stateTable = HashBasedTable.create
		traceTable = Maps.newHashMap

		debug("Running host transformations.")
		mapping.cps.hostTypes.map[instances].flatten.forEach[transform]

		debug("Running action transformations.")
		engine.depTransition.allMatches.map[depTransition].forEach[mapAction]

		reportPerformance
	}

	private def initPerformanceTimers() {
		clearModelPerformance = Stopwatch.createUnstarted
		hostTransformationPerformance = Stopwatch.createUnstarted
		appTransformationPerformance = Stopwatch.createUnstarted
		stateMachineTransformationPerformance = Stopwatch.createUnstarted
		stateTransformationPerformance = Stopwatch.createUnstarted
		transitionTransformationPerformance = Stopwatch.createUnstarted
		triggerTransformationPerformance = Stopwatch.createUnstarted

		otherTimer = Stopwatch.createUnstarted
	}

	private def reportPerformance() {
		debug(
			'''
			>>>Cleared model in: «clearModelPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>Host transformation: «hostTransformationPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>Application Instance transformation: «appTransformationPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>State Machine transformation: «stateMachineTransformationPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>State transformation: «stateTransformationPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>Transition transformation: «transitionTransformationPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>Trigger transformation: «triggerTransformationPerformance.elapsed(TimeUnit.MILLISECONDS)» ms
			>>>Other perf: «otherTimer.elapsed(TimeUnit.MILLISECONDS)» ms''')
	}

	/**
	 * Runs the transformation on the provided {@link HostInstance}. Creates the
	 * {@link DeploymentHost} in the deployment model and also runs the
	 * transformations of the applications.
	 * 
	 * @param cpsHost
	 *            The host to be transformed.
	 */
	private def void transform(HostInstance cpsHost) {
		trace('''Executing: transform(cpsHost = «cpsHost.name»)''')
		hostTransformationPerformance.start

		if (engine.cps2depTrace.getAllMatches(mapping, null, cpsHost, null).size == 0) {
			val depHost = cpsHost.createDepHost
			debug('''Adding host («depHost.description») to deployment model.''')
			mapping.deployment.hosts += depHost
			addTrace(cpsHost, depHost)

			hostTransformationPerformance.stop
			debug("Running application instance transformations.")
			cpsHost.applications.filter[type?.cps == mapping.cps].forEach [
				transform(depHost)
			]
			debug('''Running application instance transformations finished''')
			trace('''Execution ended: transform''')

		} else {
			var element = engine.cps2depTrace.getAllMatches(mapping, null, cpsHost, null).get(0).depElement
			val depHost = element as DeploymentHost
			hostTransformationPerformance.stop
			debug("Running application instance transformations.")
			cpsHost.applications.filter[type?.cps == mapping.cps].forEach [
				transform(depHost)
			]
			debug('''Running application instance transformations finished''')
			trace('''Execution ended: transform''')
		}

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
		appTransformationPerformance.start
		if (engine.cps2depTrace.getAllMatches(mapping, null, cpsInstance, null).size == 0) {

			val depApp = cpsInstance.createDepApplication

			depHost.applications += depApp
			addTrace(cpsInstance, depApp)

			appTransformationPerformance.stop
			debug("Running state machine transformations.")
			val watch = Stopwatch.createStarted
			cpsInstance.type.behavior?.transform(depApp)
			debug('''Running state machine transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			trace('''Execution ended: transform''')

		} else {

			val depApp = engine.cps2depTrace.getAllMatches(mapping, null, cpsInstance, null).get(0).depElement as DeploymentApplication

			appTransformationPerformance.stop
			debug("Running state machine transformations.")
			val watch = Stopwatch.createStarted
			cpsInstance.type.behavior?.transform(depApp)
			debug('''Running state machine transformations («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			trace('''Execution ended: transform''')
		}
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
		stateMachineTransformationPerformance.start

		val matches = engine.sm2Deploymentbehavior.getAllMatches(mapping, cpsBehavior, depApp, null)
		if (matches.size == 0) {
			val depBehavior = cpsBehavior.createDepBehavior

			depApp.behavior = depBehavior
			addTraceOneToN(cpsBehavior, #[depBehavior])

			stateMachineTransformationPerformance.stop
			debug("Running state transformations.")
			val watch = Stopwatch.createStarted
			cpsBehavior.states.forEach [
				transform(depBehavior)
			]
			debug('''Running state transformations finished''')

			debug("Resolving state relationships.")
			watch.reset.start
			cpsBehavior.states.forEach [
				buildStateRelations(depBehavior, cpsBehavior)
			]
			debug('''Resolving state relationships finished''')

			debug("Resolving initial state.")
			stateMachineTransformationPerformance.start
			watch.reset.start
			if (cpsBehavior.initial != null)
				depBehavior.current = engine.cps2depTrace.getAllMatches(mapping, null, cpsBehavior.initial, null).map[
					depElement].filter(BehaviorState).findFirst[depBehavior.states.contains(it)]
			else
				depBehavior.current = null

		}
		stateMachineTransformationPerformance.stop
		debug('''Resolving initial state finished''')
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
		stateTransformationPerformance.start
		val depState = cpsState.createDepState

		depBehavior.states += depState
		addTraceOneToN(cpsState, #[depState])

		stateTable.put(cpsState, depBehavior, depState)

		stateTransformationPerformance.stop
		trace('''Execution ended: transform''')
	}

	/**
	 * Builds the relationships between {@link BehaviorState}s. For each
	 * {@link Transition} in a {@link State} it sets the corresponding
	 * {@link BehaviorTransition}'s to property to the proper
	 * {@link BehaviorTransition}.
	 * 
	 * @param cpsState
	 *            The state for which the relation will be built.
	 * @param depBehavior
	 *            The state from cps model.
	 * @param cpsBehavior
	 *            The state from the deployment model.
	 */
	private def buildStateRelations(State cpsState, DeploymentBehavior depBehavior, StateMachine cpsBehavior) {
		trace(
			'''Executing: buildStateRelations(cpsState = «cpsState.name», depBehavior = «depBehavior.name», cpsBehavior = «cpsBehavior.
				name»)''')
		transitionTransformationPerformance.start

		val depState = stateTable.get(cpsState, depBehavior)
		cpsState.outgoingTransitions.filter[targetState != null && cpsBehavior.states.contains(targetState)].forEach [
			mapTransition(depState, depBehavior)
		]
		transitionTransformationPerformance.stop
		trace('''Execution ended: buildStateRelations''')
	}

	/**
	 * Creates a {@link BehaviorTransition} representing the {@link Transition}
	 * provided as a parameter, and adds it to its parent.
	 * 
	 * @param transition
	 *            The transitions to be transformed.
	 * @param depState The state which will refer to the transition.
	 * @param depBehavior The deployment state machine to which the new transition will be added to. 
	 */
	private def mapTransition(Transition transition, BehaviorState depState, DeploymentBehavior depBehavior) {
		trace(
			'''Executing: mapTransition(transition = «transition.name», depState = «depState.name», depBehavior = «depBehavior.
				name»)''')
		val depTransition = transition.createDepTransition

		depState.outgoing += depTransition
		depBehavior.transitions += depTransition
		otherTimer.start
		addTraceOneToN(transition, #[depTransition])
		otherTimer.stop
		depTransition.to = engine.cps2depTrace.getAllMatches(mapping, null, transition.targetState, null).map[
			depElement].filter(BehaviorState).findFirst [
			depBehavior.states.contains(it)
		]
		trace('''Execution ended: mapTransition''')
	}

	/**
	 * Sets the <i>trigger<i> value of the {@link BehaviorTransition} depending
	 * on the actions in the {@link CyberPhysicalSystem} model.
	 * 
	 * @param depTrigger
	 *            The transition for which the trigger will be set.
	 */
	private def mapAction(BehaviorTransition depTrigger) {
		trace('''Executing: mapAction(depTrigger = «depTrigger.name»)''')
		triggerTransformationPerformance.start
		val cpsTransition = engine.cps2depTrace.getAllMatches(mapping, null, null, depTrigger).map[cpsElement].head as Transition
		depTrigger.trigger += engine.triggerPair.getAllMatches(cpsTransition, null).filter [
			val triggerApp = engine.cpsApplicationTransition.getAllValuesOfcpsApp(it.cpsTrigger).head as ApplicationInstance
			val targetApp = engine.cpsApplicationTransition.getAllValuesOfcpsApp(it.cpsTarget).head as ApplicationInstance
			engine.communicatingAppInstances.countMatches(triggerApp, targetApp) > 0
		].map[engine.cps2depTrace.getAllValuesOfdepElement(mapping, null, cpsTarget)].flatten.filter(
			BehaviorTransition)
		triggerTransformationPerformance.stop
		trace('''Execution ended: mapAction''')
	}

	/**
	 * Creates a {@link DeploymentHost} representing the {@link HostInstance}
	 * provided in the parameter. Furthermore it sets the host's <i>Ip</i>.
	 * 
	 * @param cpsHost
	 *            The base of the creation.
	 * @return The created deployment host
	 */
	private def createDepHost(HostInstance cpsHost) {
		trace('''Executing: createDepHost(cpsHost = «cpsHost.name»)''')
		val depHost = depFactory.createDeploymentHost

		depHost.ip = cpsHost.nodeIp
		trace('''Execution ended: createDepHost''')
		depHost
	}

	/**
	 * Creates a {@link DeploymentApplication} representing the {@link ApplicationInstance}
	 * provided in the parameter. Furthermore it sets the application's <i>id</i>.
	 * 
	 * @param cpsHost
	 *            The base of the creation.
	 * @return The created deployment host
	 */
	private def createDepApplication(ApplicationInstance cpsAppInstance) {
		trace('''Executing: createDepApplication(cpsAppInstance = «cpsAppInstance.name»)''')
		val depApp = depFactory.createDeploymentApplication

		depApp.id = cpsAppInstance.id
		trace('''Execution: createDepApplication''')
		depApp
	}

	/**
	 * Creates a {@link DeploymentBehavior} representing the {@link StateMachine}
	 * provided in the parameter. Furthermore it sets the behavior's <i>description</i>.
	 * 
	 * @param cpsHost
	 *            The base of the creation.
	 * @return The created deployment host
	 */
	private def createDepBehavior(StateMachine cpsBehavior) {
		trace('''Executing: createDepBehavior(cpsBehavior = «cpsBehavior.name»)''')
		val depBehavior = depFactory.createDeploymentBehavior

		depBehavior.description = cpsBehavior.id
		trace('''Execution ended: createDepBehavior''')
		depBehavior
	}

	/**
	 * Creates a {@link BehaviorState} representing the {@link State}
	 * provided in the parameter. Furthermore it sets the state's <i>description</i>
	 * 
	 * @param cpsHost
	 *            The base of the creation.
	 * @return The created deployment host
	 */
	private def createDepState(State cpsState) {
		trace('''Executing: createDepState(cpsState = «cpsState.name»)''')
		val depState = depFactory.createBehaviorState

		depState.description = cpsState.id
		trace('''Execution ended: createDepState''')
		depState
	}

	/**
	 * Creates a {@link BehaviorTransition} representing the {@link Transition}
	 * provided in the parameter. Furthermore it sets the transition's <i>description</i>
	 * 
	 * @param cpsHost
	 *            The base of the creation.
	 * @return The created deployment host
	 */
	private def createDepTransition(Transition cpsTransition) {
		trace('''Executing: createDepTransition(cpsTransition = «cpsTransition.name»)''')
		val depTransition = depFactory.createBehaviorTransition

		depTransition.description = cpsTransition.id
		trace('''Execution ended: createDepTransition''')
		depTransition
	}

	/**
	 * Clears the initial model, removing every trace and host (thus deployment application etc.) from it.
	 */
	private def clearModel(ChangeDelta delta) {

		trace('''Executing: clearModel(ChangeDelta delta)''')
		val Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> queue = ArrayListMultimap.
			create();
		queue.putAll(delta.disappeared)
		queue.putAll(delta.updated)

		queue.keySet.forEach [ spec |
			queue.get(spec).forEach [ b |
				if (b instanceof HostInstance) {
					removeHostInstance(b as HostInstance)
				}
				if (b instanceof ApplicationType) {
					removeAppType(b as ApplicationType)
				}
				if (b instanceof ApplicationInstance) {
					removeAppInstance(b as ApplicationInstance)
				}
				if (b instanceof StateMachine) {
					removeStateMachine(b as StateMachine)
				}
				if (b instanceof State) {
					val state = b as State
					state.removeState
					engine.state2Statemachine.getAllMatches(state, null).forEach [ match |
						match.sm.removeStateMachine
					]
				}
				if (b instanceof Transition) {
					val transition = b as Transition
					val action = transitionMap.get(transition)
					if (action != null && SignalUtil.isWait(action)) {
						val id = SignalUtil.getSignalId(action)
						engine.sendTransitionAppSignal.getAllMatches(null, null, id).forEach [ match |
							match.transition.removeTransition
							engine.transition2StateMachine.getAllMatches(match.transition, null).forEach [ m |
								m.sm.removeStateMachine
							]
						]
					}
					transition.removeTransition
					engine.transition2StateMachine.getAllMatches(transition, null).forEach [ match |
						match.sm.removeStateMachine
					]
				}
			]
		]
		trace('''Execution ended: clearModel''')
	}

	/**
	 * Removes the deployment elements representing the specified {@link HostInstance}, as well as the elements representing its contained objects
	 * 
	 * @param {@link HostInstance} to be removed
	 */
	private def removeHostInstance(HostInstance host) {
			trace('''Executing: removeHostInstance(app = «host.name»)''')
			engine.cps2depTrace.getAllMatches(mapping, null, host, null).forEach [ c |
				mapping.traces.remove(c.trace)
				mapping.deployment.hosts.remove(c.depElement);
			]

			host.applications.forEach[app|app.removeAppInstance]

			trace('''Execution ended: removeHostInstance''')
	}

	/**
	 * Removes the deployment elements representing the specified {@link ApplicationInstance}, as well as the elements representing its contained objects
	 * 
	 * @param {@link ApplicationInstance} to be removed
	 */
	private def removeAppInstance(ApplicationInstance app) {
			trace('''Executing: removeAppinstance(app = «app.name»)''')
			engine.cps2depTrace.getAllMatches(mapping, null, app, null).forEach [ c |
				if (c.depElement != null) {
					mapping.traces.remove(c.trace)
					val depapp = c.depElement as DeploymentApplication
					engine.depApp2depHost.getAllMatches(depapp, null).forEach [ match |
						val host = match.dephost
						host.applications.remove(depapp)
					]

				}
			]
			app.type?.behavior?.removeStateMachine

			trace('''Execution ended: removeAppinstance''')
	}

	/**
	 * Removes the deployment elements representing the specified {@link ApplicationType}, as well as the elements representing its contained objects
	 * 
	 * @param {@link ApplicationType} to be removed
	 */
	private def removeAppType(ApplicationType app) {

			trace('''Executing: removeAppType(app = «app.name»)''')

			app.behavior?.removeStateMachine

			trace('''Execution ended: removeAppType''')

	}

	/**
	 * Removes the deployment elements representing the specified {@link StateMachine}, as well as the elements representing the {@link State} and {@link Transition} objects it contains
	 * 
	 * @param {@link StateMachine} to be removed
	 */
	private def void removeStateMachine(StateMachine sm) {

			trace('''Executing: removeStateMachine(sm = «sm.name»)''')
			engine.cps2depTrace.getAllMatches(mapping, null, sm, null).forEach [ c |
				if (c.depElement != null) {
					mapping.traces.remove(c.trace)
					val depBehavior = c.depElement as DeploymentBehavior
					engine.depBehavior2depApp.getAllMatches(depBehavior, null).forEach [ match |
						val app = match.depapp
						app.behavior = null;
					]

				}
			]
			sm.states.forEach [ state |
				state.removeState
				state.outgoingTransitions.forEach [ trans |
					val action = transitionMap.get(trans)
					if (action != null && SignalUtil.isWait(action)) {
						val id = SignalUtil.getSignalId(action)
						engine.sendTransitionAppSignal.getAllMatches(null, null, id).forEach [ match |
							engine.transition2StateMachine.getAllMatches(match.transition, null).forEach [ m |
								m.sm.removeStateMachine
							]
						]
					}
					trans.removeTransition
				]
			]

			trace('''Execution ended: removeState''')

	}

	/**
	 * Removes the deployment elements representing the specified {@link State}
	 * @param State to be removed
	 */
	private def removeState(State state) {

			trace('''Executing: removeState(trans = «state.name»)''')
			engine.cps2depTrace.getAllMatches(mapping, null, state, null).forEach [ c |
				if (c.depElement != null) {
					mapping.traces.remove(c.trace)
				}
			]

			trace('''Execution ended: removeState''')


	}

	/**
	 * Removes the deployment elements representing the specified {@link Transition}
	 * @param Transition to be removed
	 */
	private def removeTransition(Transition trans) {
			trace('''Executing: removeTransition(trans = «trans.name»)''')
			engine.cps2depTrace.getAllMatches(mapping, null, trans, null).forEach [ c |
				if (c.depElement != null) {
					mapping.traces.remove(c.trace)
					val depTrans = c.depElement as BehaviorTransition
					depTrans.trigger.clear
				}
			]

			trace('''Execution ended: removeTransition''')
	}

	/**
 	 * Creates a 1-N trace between the specified elements and adds it to the traceability model.
 	 * @param cpsElement The element in the cps model
 	 * @param depElements The elements in the deployment model 
 	 */
	private def addTraceOneToN(Identifiable cpsElement, List<? extends DeploymentElement> depElements) {
		trace(
			'''Executing: addTraceOneToN(cpsElement = «cpsElement.name», depElements = [«FOR e : depElements SEPARATOR ", "»«e.
				name»«ENDFOR»])''')

		//var trace = engine.cps2depTrace.getOneArbitraryMatch(mapping, null, cpsElement, null)?.trace
		var trace = traceTable.get(cpsElement)
		if (trace == null) {
			trace = tracFactory.createCPS2DeplyomentTrace
			traceTable.put(cpsElement, trace)

			trace.cpsElements += cpsElement
		}
		trace.deploymentElements += depElements

		debug(
			'''Adding trace («cpsElement.name»->[«FOR e : depElements SEPARATOR ", "»«e.name»«ENDFOR»]) to traceability model.''')
		mapping.traces += trace
		trace('''Execution ended: addTraceOneToN''')
	}

	/**
 	 * Creates a 1-1 trace between the specified elements and adds it to the traceability model.
 	 * @param cpsElement The element in the cps model
 	 * @param depElements The element in the deployment model 
 	 */
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
