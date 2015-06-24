package org.eclipse.incquery.examples.cps.performance.tests.config.scenarios

import eu.mondo.sam.core.phases.SequencePhase
import org.eclipse.incquery.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.EMFResourceInitializationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.EmptyPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.InitializationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.M2MTransformationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.M2TTransformationPhase

/*
 * Scenario for given model statistics
 */
class ToolChainPerformanceBatchScenario extends CPSBenchmarkScenario {
	new(BenchmarkCase benchmarkCase) {
		super(benchmarkCase)
	}
	
	override build() {
		
		val seq = new SequencePhase
		seq.addPhases(
			new EMFResourceInitializationPhase("EMFResourceInitialization"),
			benchmarkCase.getGenerationPhase("Generation"),
			new InitializationPhase("Initialization"),
			new M2MTransformationPhase("M2MTransformation1"),
			new M2TTransformationPhase("M2TTransformation1"),
			new EmptyPhase("ChangeMonitorInitialization"),
			benchmarkCase.getModificationPhase("Modification"),
			new M2MTransformationPhase("M2MTransformation2"),
			new M2TTransformationPhase("M2TTransformation2")
		)
		rootPhase = seq
	}
	
	override getName() {
		return "ToolChainPerformanceBatch"
	}

}
