package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules

import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.StateMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum
import org.eclipse.incquery.examples.cps.deployment.BehaviorState

class StateRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new StateMapping(engine).specification
		}
	}
}

class StateMapping extends AbstractRule<StateMatch> {
	new(IncQueryEngine engine) {
		super(engine)
	}

	override getSpecification() {
		createPriorityRuleSpecification => [
			ruleSpecification = Rules.newMatcherRuleSpecification(state, Lifecycles.getDefault(true, true),
				#{appearedJob, updateJob, disappearedJob})
			priority = 4
		]
	}

	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED,
			[ StateMatch match |
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.appInstance).head as DeploymentApplication
				val depBehavior = depApp.behavior
				val state = match.state
				val stateId = state.id
				debug('''Mapping state with ID: «stateId»''')
				val depState = createBehaviorState => [
					description = stateId
				]
				depBehavior.states += depState
				if (match.stateMachine.initial == state) {
					depBehavior.current = depState
				}
				val traces = engine.cps2depTrace.getAllValuesOftrace(null, state, null)
				if (traces.empty) {
					trace('''Creating new trace for state ''')
					rootMapping.traces += createCPS2DeplyomentTrace => [
						cpsElements += state
						deploymentElements += depState
					]
				} else {
					trace('''Adding new state to existing trace''')
					traces.head.deploymentElements += depState
				}
				debug('''Mapped state with ID: «stateId»''')
			])
	}

	private def getUpdateJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED,
			[ StateMatch match |
				val state = match.state
				val stateId = state.id
				debug('''Updating mapped state with ID: «stateId»''')
				val depStates = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.state).filter(
					BehaviorState)
				depStates.forEach [
					val depBehavior = engine.depBehaviorsState.getAllValuesOfdepBehavior(it).head
					val oldDesc = description
					if (oldDesc != stateId) {
						trace('''ID changed to «stateId»''')
						description = stateId
					}
					val initState = match.stateMachine.initial
					if (state == initState) {
						val currentState = depBehavior.current
						if (currentState != it) {
							trace('''Current state changed to «stateId»''')
							depBehavior.current = it
						}
					}
				]
				debug('''Updated mapped state with ID: «stateId»''')
			])
	}

	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED,
			[ StateMatch match |
				val depApp = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.appInstance).head as DeploymentApplication
				val depBehavior = depApp.behavior
				val depState = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.state).filter(BehaviorState).findFirst[depApp.behavior.states.contains(it)];
				val stateId = depState.description
				logger.debug('''Removing state with ID: «stateId»''')
				if (depBehavior != null) {
					depBehavior.states -= depState
					if (depBehavior.current == depState) {
						depBehavior.current = null
					}
				}
				val smTrace = engine.cps2depTrace.getAllValuesOftrace(null, match.state, null).head
				smTrace.deploymentElements -= depState
				if (smTrace.deploymentElements.empty) {
					trace('''Removing empty trace''')
					rootMapping.traces -= smTrace
				}
				logger.debug('''Removed state with ID: «stateId»''')
			])
	}

}
