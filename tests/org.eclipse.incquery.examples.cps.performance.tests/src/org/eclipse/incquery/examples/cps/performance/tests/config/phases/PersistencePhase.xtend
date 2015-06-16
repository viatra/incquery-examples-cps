package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.phases.OptionalPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil

class PersistencePhase extends OptionalPhase{
	
	new(){
		phase = new PersistenceAtomicPhase("Persistence")
	}
	
	override condition() {
		PropertiesUtil.persistResults
	}
}


class PersistenceAtomicPhase extends AtomicPhase{
	
	new(String name) {
		super(name)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val persistenceTimer = new TimeMetric("Time")
		val persistenceMemory = new MemoryMetric("Memory")
		
		persistenceTimer.startMeasure
		cpsToken.cps2dep.eResource.resourceSet.resources.forEach[save(null)]
		persistenceTimer.stopMeasure
		persistenceMemory.measure
		phaseResult.addMetrics(persistenceTimer, persistenceMemory)
	}
	
	
}