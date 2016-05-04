package org.eclipse.viatra.examples.cps.performance.tests

import java.util.Random
import org.eclipse.viatra.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.viatra.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.viatra.examples.cps.performance.tests.config.scenarios.BasicXformScenario
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.TransformationType

abstract class BasicXformTest extends PropertiesBasedTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	override getScenario(int scale, Random rand) {
		return new BasicXformScenario(getCase(scale, rand))
	}
	
	def BenchmarkCase getCase(int scale, Random rand)
	
}