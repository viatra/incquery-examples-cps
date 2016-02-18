package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules

import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.ApplicationInstanceMatch
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.transformation.evm.specific.Jobs
import org.eclipse.viatra.transformation.evm.specific.Lifecycles
import org.eclipse.viatra.transformation.evm.specific.Rules
import org.eclipse.viatra.transformation.evm.specific.event.IncQueryActivationStateEnum

class ApplicationRules {
	static def getRules(ViatraQueryEngine engine) {
		#{
			new ApplicationMapping(engine).specification
		}
	}
}

class ApplicationMapping extends AbstractRule<ApplicationInstanceMatch> {

	new(ViatraQueryEngine engine) {
		super(engine)
	}

	override getSpecification() {
		createPriorityRuleSpecification => [
			ruleSpecification = Rules.newMatcherRuleSpecification(applicationInstance, Lifecycles.getDefault(true, true),
				#{appearedJob, updateJob, disappearedJob})
			priority = 2
		]
	}

	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED,
			[ ApplicationInstanceMatch match |
				val depHost = engine.cps2depTrace.getAllValuesOfdepElement(null, null, match.appInstance.allocatedTo).filter(DeploymentHost).head
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
				val depApp = engine.cps2depTrace.getOneArbitraryMatch(rootMapping, null, match.appInstance, null).
					depElement as DeploymentApplication
				if (depApp.id != match.appInstance.id)
					depApp.id = match.appInstance.id
			])
	}

	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED,
			[ ApplicationInstanceMatch match |
				val trace = engine.cps2depTrace.getAllValuesOftrace(null, match.appInstance, null).filter(CPS2DeplyomentTrace).head
				val depApp = trace.deploymentElements.head as DeploymentApplication
				engine.allocatedDeploymentApplication.getAllValuesOfdepHost(depApp).head.applications -= depApp
				rootMapping.traces -= trace
			])
	}
}
