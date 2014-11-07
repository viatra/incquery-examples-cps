package org.eclipse.incquery.examples.cps.xform.m2m.rules

import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2m.HostInstancesMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum

class HostMappingRule extends AbstractRule<HostInstancesMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(hostInstances, #{appearedJob, disappearedJob})
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [HostInstancesMatch match |
			val nodeIp = match.hostInstance.nodeIp
			logger.debug('''Mapping host with IP: «nodeIp»''')
			val host = createDeploymentHost => [
				ip = nodeIp
			]
			rootMapping.deployment.hosts += host
			rootMapping.traces += createCPS2DeplyomentTrace => [
				cpsElements += match.hostInstance
				deploymentElements += host
			]
			logger.debug('''Mapped host with IP: «nodeIp»''')
		])
	} 
	
	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED, [HostInstancesMatch match |
			logger.debug('''Removing host with IP: «match.hostInstance.nodeIp»''')
			val traces = getCps2depTrace(engine).getAllValuesOftrace(rootMapping, match.hostInstance, null)
			rootMapping.deployment.hosts -= traces.map[deploymentElements].flatten.filter(typeof(DeploymentHost)).toList
			rootMapping.traces -= traces
			logger.debug('''Removed host with IP: «match.hostInstance.nodeIp»''')
		])
	} 
}