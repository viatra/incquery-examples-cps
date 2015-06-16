package org.eclipse.incquery.examples.cps.performance.tests.config.scenarios

import eu.mondo.sam.core.phases.SequencePhase
import org.eclipse.incquery.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.ChangeMonitorInitializationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.EMFResourceInitializationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.InitializationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.M2MTransformationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.M2TDeltaTransformationPhase
import org.eclipse.incquery.examples.cps.performance.tests.config.phases.M2TTransformationPhase

/*
 * Scenario for given model statistics
 */
class ToolChainPerformanceIncrementalScenario extends CPSBenchmarkScenario {
	new(BenchmarkCase benchmarkCase) {
		super(benchmarkCase)
	}
	
	override build() {
		
		val seq = new SequencePhase
		seq.addPhases(
			new EMFResourceInitializationPhase("EMFResourceInitialization"),
			benchmarkCase.getGenerationPhase("Generation"),
			new InitializationPhase("Initialization"),
			new M2MTransformationPhase("M2MTransformation"),
			new M2TTransformationPhase("M2TTransformation"),
			new ChangeMonitorInitializationPhase("ChangeMonitorInitialization"),
			benchmarkCase.getModificationPhase("Modification"),
			new M2MTransformationPhase("M2MTransformation"),
			new M2TDeltaTransformationPhase("M2TTransformation")
		)
		rootPhase = seq
	}
	
	override getName() {
		return "ToolChainPerformanceIncremental"
	}

}
