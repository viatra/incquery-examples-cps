package org.eclipse.incquery.examples.cps.generator.utils

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.dtos.CPSStats
import org.eclipse.incquery.runtime.api.IncQueryEngine

class StatsUtil {
	
	def static logStats(CPSStats stats, Logger logger) {
		logger.info("Model Stats: ");
		logger.info("  ApplicationTypes: " + stats.appTypeCount);
		logger.info("  ApplicationInstances: " + stats.appInstanceCount);
		logger.info("  HostTypes: " + stats.hostTypeCount);
		logger.info("  HostInstances: " + stats.hostInstanceCount);
		logger.info("  States: " + stats.stateCount);
		logger.info("  Transitions: " + stats.transitionCount);
		logger.info("  Allocated AppInstances: " + stats.allocatedAppCount);
		logger.info("  Connected HostsInstances: " + stats.connectedHostCount);
		logger.info("");
	}
	
	def static generateStats(IncQueryEngine engine){
		return new CPSStats(engine);
	}
}