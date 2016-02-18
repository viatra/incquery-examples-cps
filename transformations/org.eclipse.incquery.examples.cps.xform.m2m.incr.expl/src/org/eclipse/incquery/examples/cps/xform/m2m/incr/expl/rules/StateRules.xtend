package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules

import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.DeletedStateMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.MonitoredStateMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.UnmappedStateMatch
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.transformation.evm.specific.Jobs
import org.eclipse.viatra.transformation.evm.specific.Lifecycles
import org.eclipse.viatra.transformation.evm.specific.Rules
import org.eclipse.viatra.transformation.evm.specific.event.IncQueryActivationStateEnum

class StateRules {
	static def getRules(ViatraQueryEngine engine) {
		#{
			new StateMapping(engine).specification
			,new StateUpdate(engine).specification
			,new StateRemoval(engine).specification
		}
	}
}

class StateMapping extends AbstractRule<UnmappedStateMatch> {
	
	new(ViatraQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			unmappedState,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [UnmappedStateMatch match |
			val state = match.state
			val stateId = state.id
			debug('''Mapping state with ID: «stateId»''')
			val depState = createBehaviorState => [
				description = stateId
			]
			match.depBehavior.states += depState
			if(match.stateMachine.initial == state){
				match.depBehavior.current = depState
			}
			val traces = engine.cps2depTrace.getAllValuesOftrace(null, state, null)
			if(traces.empty){
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
}

class StateUpdate extends AbstractRule<MonitoredStateMatch> {
	
	new(ViatraQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			monitoredState,
			Lifecycles.getDefault(true, true),
			#{appearedJob, disappearedJob, updatedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [MonitoredStateMatch match |
			val stateId = match.state.id
			debug('''Starting monitoring mapped state with ID: «stateId»''')
		])
	}
	
	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED, [MonitoredStateMatch match |
			val stateId = match.state.id
			debug('''Stopped monitoring mapped state with ID: «stateId»''')
		])
	}
	
	private def getUpdatedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED, [MonitoredStateMatch match |
			val state = match.state
			val stateId = state.id
			debug('''Updating mapped state with ID: «stateId»''')
			val depStateMatches = getMappedState(engine).getAllMatches(state, null, null, null)
			depStateMatches.forEach[
				val oldDesc = depState.description
				if(oldDesc != stateId){
					trace('''ID changed to «stateId»''')
					depState.description = stateId
				}
				val initState = stateMachine.initial
				if(state == initState){
					val currentState = depBehavior.current 
					if(currentState != depState){
						trace('''Current state changed to «stateId»''')
						depBehavior.current = depState
					}
				}
			]
			debug('''Updated mapped state with ID: «stateId»''')
		])
	}
}

class StateRemoval extends AbstractRule<DeletedStateMatch> {
	
	new(ViatraQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			deletedState,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [DeletedStateMatch match |
			val depState = match.depState as BehaviorState
			val stateId = depState.description
			logger.debug('''Removing state with ID: «stateId»''')
			val stateMachines = engine.behaviorState.getAllValuesOfdepBehavior(depState)
			if(!stateMachines.empty){
				val sm = stateMachines.head
				sm.states -= depState
				if(sm.current == depState){
					sm.current = null
				}
			}
			val smTrace = match.trace
			smTrace.deploymentElements -= depState
			if(smTrace.deploymentElements.empty){
				trace('''Removing empty trace''')
				rootMapping.traces -= smTrace
			}
			logger.debug('''Removed state with ID: «stateId»''')
		])
	} 
}