package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules

import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.ApplicationInstanceMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum

class ApplicationRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new ApplicationMapping(engine).specification
		}
	}
}

class ApplicationMapping extends AbstractRule<ApplicationInstanceMatch> {

	new(IncQueryEngine engine) {
		super(engine)
	}

	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			applicationInstance,
			Lifecycles.getDefault(true, true),
			#{appearedJob, updateJob, disappearedJob}
		)
	}

	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED,
			[ ApplicationInstanceMatch match |
				val depHost = engine.cps2depTrace.getOneArbitraryMatch(rootMapping, null, match.host, null).depElement as DeploymentHost
				val appId = match.appInstance.id
				debug('''Mapping application with ID: «appId»''')
				val app = createDeploymentApplication => [
					id = appId
				]
				depHost.applications += app
				rootMapping.traces += createCPS2DeplyomentTrace => [
					cpsElements += match.appInstance
					deploymentElements += app
				]
				debug('''Mapped application with ID: «appId»''')
			])
	}

	private def getUpdateJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED,
			[ ApplicationInstanceMatch match |
				])
		}

		private def getDisappearedJob() {
			Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED,
				[ ApplicationInstanceMatch match |
					val depHost = engine.cps2depTrace.getOneArbitraryMatch(rootMapping, null, match.host, null).
						depElement as DeploymentHost
					val traceMatch = engine.cps2depTrace.getOneArbitraryMatch(rootMapping, null, match.appInstance, null)
					val depApp = traceMatch.depElement as DeploymentApplication
					
					depHost.applications -= depApp
					rootMapping.traces -= traceMatch.trace
				])
		}

	}
	