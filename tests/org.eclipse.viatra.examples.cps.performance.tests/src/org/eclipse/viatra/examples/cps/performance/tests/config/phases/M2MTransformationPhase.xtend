package org.eclipse.viatra.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.viatra.examples.cps.performance.tests.config.CPSDataToken

class M2MTransformationPhase extends AtomicPhase{
	
	new(String name) {
		super(name)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken =token as CPSDataToken
		val timer = new TimeMetric("Time")
		val memory = new MemoryMetric("Memory")
		
		timer.startMeasure
		cpsToken.xform.executeTransformation
		timer.stopMeasure
		memory.measure
		
		phaseResult.addMetrics(timer, memory)
	}
	
}