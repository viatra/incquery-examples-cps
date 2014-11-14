package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules

import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.DeletedDeploymentHostMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.MappedHostInstanceMatch
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.UnmappedHostInstanceMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum

class HostRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new HostMapping(engine).specification
			,new HostUpdate(engine).specification
			,new HostRemoval(engine).specification
		}
	}
}

class HostMapping extends AbstractRule<UnmappedHostInstanceMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			unmappedHostInstance,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [UnmappedHostInstanceMatch match |
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
	
}

class HostUpdate extends AbstractRule<MappedHostInstanceMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			mappedHostInstance,
			Lifecycles.getDefault(true, true),
			#{appearedJob, disappearedJob, updatedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [MappedHostInstanceMatch match |
			val hostIp = match.depHost.ip
			debug('''Starting monitoring mapped host with IP: «hostIp»''')
		])
	}
	
	private def getDisappearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.DISAPPEARED, [MappedHostInstanceMatch match |
			val hostIp = match.depHost.ip
			debug('''Stopped monitoring mapped host with IP: «hostIp»''')
		])
	}
	
	private def getUpdatedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.UPDATED, [MappedHostInstanceMatch match |
			val hostIp = match.depHost.ip
			debug('''Updating mapped host with IP: «hostIp»''')
			val nodeIp = match.hostInstance.nodeIp
			if(nodeIp != hostIp){
				trace('''IP changed to «nodeIp»''')
				match.depHost.ip = nodeIp
			}
			debug('''Updated mapped host with IP: «nodeIp»''')
		])
	}
}

class HostRemoval extends AbstractRule<DeletedDeploymentHostMatch> {
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			deletedDeploymentHost,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [DeletedDeploymentHostMatch match |
			val depHost = match.depHost
			val hostIp = depHost.ip
			logger.debug('''Removing host with IP: «hostIp»''')
			rootMapping.deployment.hosts -= depHost
			rootMapping.traces -= match.trace
			logger.debug('''Removed host with IP: «hostIp»''')
		])
	} 
}