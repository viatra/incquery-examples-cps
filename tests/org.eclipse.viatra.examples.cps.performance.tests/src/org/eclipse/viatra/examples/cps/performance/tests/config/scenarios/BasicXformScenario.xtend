package org.eclipse.viatra.examples.cps.performance.tests.config.scenarios

import eu.mondo.sam.core.phases.IterationPhase
import eu.mondo.sam.core.phases.SequencePhase
import org.eclipse.viatra.examples.cps.generator.utils.RandomUtils
import org.eclipse.viatra.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.viatra.examples.cps.performance.tests.config.phases.EMFResourceInitializationPhase
import org.eclipse.viatra.examples.cps.performance.tests.config.phases.InitializationPhase
import org.eclipse.viatra.examples.cps.performance.tests.config.phases.M2MTransformationPhase

class BasicXformScenario extends CPSBenchmarkScenario {
	protected extension RandomUtils randUtil = new RandomUtils;

	new(BenchmarkCase benchmarkCase) {
		super(benchmarkCase)
	}

	override build() {
		val seq = new SequencePhase
		val innerSeq = new SequencePhase
		innerSeq.addPhases(
			benchmarkCase.getModificationPhase("Modification"),
			new M2MTransformationPhase("Transformation")
		)

		val iter = new IterationPhase(2)
		iter.phase = innerSeq

		seq.addPhases(
			new EMFResourceInitializationPhase("ResourceInitialization"),
			benchmarkCase.getGenerationPhase("Generation"),
			new InitializationPhase("Initialization"),
			new M2MTransformationPhase("Transformation"),
			iter
		)
		rootPhase = seq
	}
	
	override getName() {
		"BasicXform"
	}
}