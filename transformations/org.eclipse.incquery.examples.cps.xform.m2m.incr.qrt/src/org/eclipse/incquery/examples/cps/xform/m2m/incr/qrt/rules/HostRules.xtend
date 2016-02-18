package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules

import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.HostInstanceMatch
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.transformation.evm.specific.Jobs
import org.eclipse.viatra.transformation.evm.specific.Lifecycles
import org.eclipse.viatra.transformation.evm.specific.Rules
import org.eclipse.viatra.transformation.evm.specific.event.IncQueryActivationStateEnum

class HostRules {
	static def getRules(ViatraQueryEngine engine) {
		#{
			new HostMapping(engine).specification
		}
	}
}

class HostMapping extends AbstractRule<HostInstanceMatch> {

	new(ViatraQueryEngine engine) {
		super(engine)
	}

	override getSpecification() {
		createPriorityRuleSpecification => [
			ruleSpecification = Rules.newMatcherRuleSpecification(hostInstance, Lifecycles.getDefault(true, true),
			#{appearedJob, updateJob, disappearedJob})
			priority = 1
		]
	}

	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED,
			[ HostInstanceMatch match |
				val nodeIp = match.hostInstance.nodeIp
				debug('''Mapping host with IP: «nodeIp»''')
				val host = createDeploymentHost => [
					ip = nodeIp
				]
				rootMapping.deployment.hosts += host
				rootMapping.traces += createCPS2DeplyomentTrace => [
					cpsElements += match.hostInstance
					deploymentElements += host
				]
				debug('''Mapped host with IP: «nodeIp»''')
			])
	}

	private def getUpdateJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED,
			[ HostInstanceMatch match |
				val depHost = engine.cps2depTrace.getOneArbitraryMatch(rootMapping, null, match.hostInstance, null).
					depElement as DeploymentHost
				val hostIp = depHost.ip
				debug('''Updating mapped host with IP: «hostIp»''')
				val nodeIp = match.hostInstance.nodeIp
				if (nodeIp != hostIp) {
					trace('''IP changed to «nodeIp»''')
					depHost.ip = nodeIp
				}
				debug('''Updated mapped host with IP: «nodeIp»''')
			])
	}

	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED,
			[ HostInstanceMatch match |
				val traceMatch = engine.cps2depTrace.getOneArbitraryMatch(rootMapping, null, match.hostInstance,
					null)
				val hostIp = match.hostInstance.nodeIp
				logger.debug('''Removing host with IP: «hostIp»''')
				rootMapping.deployment.hosts -= traceMatch.depElement as DeploymentHost
				rootMapping.traces -= traceMatch.trace
				logger.debug('''Removed host with IP: «hostIp»''')
			])
	}

}
