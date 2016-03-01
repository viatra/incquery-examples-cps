package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules

import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.DeletedTriggerMatch
import org.eclipse.viatra.transformation.evm.specific.crud.CRUDActivationStateEnum
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.UnmappedTriggerMatch
import org.eclipse.viatra.transformation.evm.specific.Rules
import org.eclipse.viatra.transformation.evm.specific.Lifecycles
import org.eclipse.viatra.transformation.evm.specific.Jobs

class TriggerRules {
	static def getRules(ViatraQueryEngine engine) {
		#{
			new TriggerMapping(engine).specification
			,new TriggerRemoval(engine).specification
		}
	}
}

class TriggerMapping extends AbstractRule<UnmappedTriggerMatch> {
	
	new(ViatraQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			unmappedTrigger,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(CRUDActivationStateEnum.APPEARED, [UnmappedTriggerMatch match |
			val sendTr = match.depSendTransition
			val waitTr = match.depWaitTransition
			debug('''Mapping trigger between «sendTr.description» and «waitTr.description»''')
			
			if(!sendTr.trigger.contains(waitTr)) {
				trace('''Adding new trigger''')
				sendTr.trigger += waitTr
			}

			debug('''Mapped trigger between «sendTr.description» and «waitTr.description»''')
		])
	}
}

class TriggerRemoval extends AbstractRule<DeletedTriggerMatch> {
	
	new(ViatraQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			deletedTrigger,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(CRUDActivationStateEnum.APPEARED, [DeletedTriggerMatch match |
			val sendTr = match.depSendTransition
			val waitTr = match.depWaitTransition
			debug('''Removing trigger between «sendTr.description» and «waitTr.description»''')
			
			if(sendTr.trigger.contains(waitTr)) {
				trace('''Removing existing trigger''')
				sendTr.trigger -= waitTr
			}

			debug('''Removing trigger between «sendTr.description» and «waitTr.description»''')
		])
	} 
}