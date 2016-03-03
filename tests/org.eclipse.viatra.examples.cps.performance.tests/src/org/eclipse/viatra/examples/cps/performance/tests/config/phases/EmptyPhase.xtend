package org.eclipse.viatra.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult

class EmptyPhase extends AtomicPhase {

	new(String phaseName) {
		super("Empty" + phaseName)
	}

	override execute(DataToken token, PhaseResult phaseResult) {
		val emptyTimer = new TimeMetric("Time")
		val emptyMemory = new MemoryMetric("Memory")
		emptyTimer.startMeasure
		emptyTimer.stopMeasure
		emptyMemory.measure
		phaseResult.addMetrics(emptyTimer, emptyMemory)
	}

}