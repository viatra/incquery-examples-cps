package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules

import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.TriggerPairMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition

class TriggerRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new TriggerMapping(engine).specification
		}
	}
}

class TriggerMapping extends AbstractRule<TriggerPairMatch> {
	new(IncQueryEngine engine) {
		super(engine)
	}

	override getSpecification() {
		createPriorityRuleSpecification => [
			ruleSpecification = Rules.newMatcherRuleSpecification(triggerPair, Lifecycles.getDefault(true, true),
				#{appearedJob, disappearedJob})
			priority = 6
		]
	}

	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED,
			[ TriggerPairMatch match |
				val depAppTrigger = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.appInstanceTrigger).
					filter(DeploymentApplication).head
				val depAppTarget = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.appInstanceTarget).
					filter(DeploymentApplication).head
				val sendTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.cpsTrigger).filter(
					BehaviorTransition).findFirst[depAppTrigger.behavior.transitions.contains(it)]
				val waitTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.cpsTarget).filter(
					BehaviorTransition).findFirst[depAppTarget.behavior.transitions.contains(it)]
				debug('''Mapping trigger between «sendTr.description» and «waitTr.description»''')
				if (!sendTr.trigger.contains(waitTr)) {
					trace('''Adding new trigger''')
					sendTr.trigger += waitTr
				}
				debug('''Mapped trigger between «sendTr.description» and «waitTr.description»''')
			])
	}

	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED,
			[ TriggerPairMatch match |
				val depAppTrigger = engine.cps2depTrace.getAllValuesOfdepElement(null, null,
					match.appInstanceTrigger).filter(DeploymentApplication).head
				val depAppTarget = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.appInstanceTarget).
					filter(DeploymentApplication).head
				val sendTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.cpsTrigger).filter(
					BehaviorTransition).findFirst[depAppTrigger.behavior.transitions.contains(it)]
				val waitTr = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.cpsTarget).filter(
					BehaviorTransition).findFirst[depAppTarget.behavior.transitions.contains(it)]
				debug('''Removing trigger between «sendTr.description» and «waitTr.description»''')
				if (sendTr.trigger.contains(waitTr)) {
					trace('''Removing existing trigger''')
					sendTr.trigger -= waitTr
				}
				debug('''Removing trigger between «sendTr.description» and «waitTr.description»''')
			])
	}

}
