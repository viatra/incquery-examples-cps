package org.eclipse.incquery.examples.cps.performance.tests

import java.util.Random
import org.eclipse.incquery.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.config.TransformationType
import org.eclipse.incquery.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.incquery.examples.cps.performance.tests.config.scenarios.ToolChainPerformanceIncrementalScenario

abstract class ToolchainPerformanceTest extends PropertiesBasedTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType) {
		super(wrapperType, scale, generatorType)
	}
	
	override getScenario(int scale, Random rand) {
		return new ToolChainPerformanceIncrementalScenario(getCase(scale, rand))
	}
	
	def BenchmarkCase getCase(int scale, Random rand);
	
}