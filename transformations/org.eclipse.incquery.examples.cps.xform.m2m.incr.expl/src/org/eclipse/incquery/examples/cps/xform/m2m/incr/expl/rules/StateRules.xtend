package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules

import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.DeletedStateMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.MappedStateMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.UnmappedStateMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum

class StateRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new StateMapping(engine).specification
			,new StateUpdate(engine).specification
			,new StateRemoval(engine).specification
		}
	}
}

class StateMapping extends AbstractRule<UnmappedStateMatch> {
	
	new(IncQueryEngine engine) {
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

class StateUpdate extends AbstractRule<MappedStateMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			mappedState,
			Lifecycles.getDefault(true, true),
			#{appearedJob, disappearedJob, updatedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [MappedStateMatch match |
			val stateId = match.depState.description
			debug('''Starting monitoring mapped state with ID: «stateId»''')
		])
	}
	
	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED, [MappedStateMatch match |
			val stateId = match.depState.description
			debug('''Stopped monitoring mapped state with ID: «stateId»''')
		])
	}
	
	private def getUpdatedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED, [MappedStateMatch match |
			val depState = match.depState
			val stateId = depState.description
			debug('''Updating mapped state with ID: «stateId»''')
			val newId = match.state.id
			if(newId != stateId){
				trace('''ID changed to «newId»''')
				depState.description = newId
			}
			val initState = match.stateMachine.initial
			if(match.state == initState){
				val depBehavior = match.depBehavior
				val currentState = depBehavior.current 
				if(currentState != depState){
					depBehavior.current = depState
				}
			}
			debug('''Updated mapped state with IDP: «newId»''')
		])
	}
}

class StateRemoval extends AbstractRule<DeletedStateMatch> {
	
	new(IncQueryEngine engine) {
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