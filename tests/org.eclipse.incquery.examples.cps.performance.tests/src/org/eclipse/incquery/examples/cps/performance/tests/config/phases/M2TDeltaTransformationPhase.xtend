package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.incquery.examples.cps.xform.m2t.api.ChangeM2TOutputProvider
import org.eclipse.incquery.examples.cps.xform.serializer.DefaultSerializer
import org.eclipse.incquery.examples.cps.xform.serializer.eclipse.EclipseBasedFileAccessor

class M2TDeltaTransformationPhase extends AtomicPhase {
	protected extension DefaultSerializer serializer = new DefaultSerializer

	new(String name) {
		super(name)
	}

	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val timer = new TimeMetric("Time")
		val memory = new MemoryMetric("Memory")

		timer.startMeasure

		val monitor = cpsToken.changeMonitor
		val generator = cpsToken.codeGenerator
		val folder = cpsToken.srcFolder
		val folderString = folder.location.toOSString
		val delta = monitor.deltaSinceLastCheckpoint
	
		
		val changeprovider = new ChangeM2TOutputProvider(delta, generator, folderString)
		folderString.serialize(changeprovider, new EclipseBasedFileAccessor)

		timer.stopMeasure
		memory.measure

		phaseResult.addMetrics(timer, memory)
	}
}