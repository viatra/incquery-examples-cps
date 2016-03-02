package org.eclipse.viatra.examples.cps.performance.tests

import java.util.Random
import org.eclipse.viatra.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.viatra.examples.cps.performance.tests.config.TransformationType
import org.eclipse.viatra.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.viatra.examples.cps.performance.tests.config.scenarios.ToolChainPerformanceIncrementalScenario
import org.eclipse.viatra.examples.cps.performance.tests.config.scenarios.ToolChainPerformanceBatchScenario

abstract class ToolchainPerformanceTest extends PropertiesBasedTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	override getScenario(int scale, Random rand) {
		if (wrapperType.isIncremental){
			return new ToolChainPerformanceIncrementalScenario(getCase(scale, rand))
		} else {
			return new ToolChainPerformanceBatchScenario(getCase(scale, rand))
		}
	}
	
	def BenchmarkCase getCase(int scale, Random rand);
	
}