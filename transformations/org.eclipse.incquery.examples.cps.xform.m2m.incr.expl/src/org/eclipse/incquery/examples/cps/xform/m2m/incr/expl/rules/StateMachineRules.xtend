package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules

import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.DeletedStateMachineMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.MappedStateMachineMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.UnmappedStateMachineMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum

class StateMachineRules {
    static def getRules(IncQueryEngine engine) {
		#{
			new StateMachineMapping(engine).specification
			,new StateMachineUpdate(engine).specification
			,new StateMachineRemoval(engine).specification
		}
	}
}

class StateMachineMapping extends AbstractRule<UnmappedStateMachineMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			unmappedStateMachine,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [UnmappedStateMachineMatch match |
			val smId = match.stateMachine.id
			debug('''Mapping state machine with ID: «smId»''')
			val behavior = createDeploymentBehavior => [
				description = smId
			]
			match.depApp.behavior = behavior
			val traces = engine.cps2depTrace.getAllValuesOftrace(null, match.stateMachine, null)
			if(traces.empty){
				trace('''Creating new trace for state machine''')
				rootMapping.traces += createCPS2DeplyomentTrace => [
					cpsElements += match.stateMachine
					deploymentElements += behavior
				]
			} else {
				trace('''Adding new behavior to existing trace''')
				traces.head.deploymentElements += behavior
			}
			debug('''Mapped state machine with ID: «smId»''')
		])
	}
	
}

class StateMachineUpdate extends AbstractRule<MappedStateMachineMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			mappedStateMachine,
			Lifecycles.getDefault(true, true),
			#{appearedJob, disappearedJob, updatedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [MappedStateMachineMatch match |
			val smId = match.depBehavior.description
			debug('''Starting monitoring mapped state machine with ID: «smId»''')
		])
	}
	
	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED, [MappedStateMachineMatch match |
			val smId = match.depBehavior.description
			debug('''Stopped monitoring mapped state machine with ID: «smId»''')
		])
	}
	
	private def getUpdatedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED, [MappedStateMachineMatch match |
			val smId = match.depBehavior.description
			debug('''Updating mapped state machine with ID: «smId»''')
			val newId = match.stateMachine.id
			if(newId != smId){
				trace('''ID changed to «newId»''')
				match.depBehavior.description = newId
			}
			debug('''Updated mapped state machine with IDP: «newId»''')
		])
	}
}

class StateMachineRemoval extends AbstractRule<DeletedStateMachineMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			deletedStateMachine,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [DeletedStateMachineMatch match |
			val depBehavior = match.depBehavior as DeploymentBehavior
			val smId = depBehavior.description
			logger.debug('''Removing state machine with ID: «smId»''')
			val apps = engine.deploymentApplicationBehavior.getAllValuesOfdepApp(depBehavior)
			if(!apps.empty){
				apps.head.behavior = null
			}
			val smTrace = match.trace
			smTrace.deploymentElements -= depBehavior
			if(smTrace.deploymentElements.empty){
				trace('''Removing empty trace''')
				rootMapping.traces -= smTrace
			}
			logger.debug('''Removed state machine with ID: «smId»''')
		])
	} 
}