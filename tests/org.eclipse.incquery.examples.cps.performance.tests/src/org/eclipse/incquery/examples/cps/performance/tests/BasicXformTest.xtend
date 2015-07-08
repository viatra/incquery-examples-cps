package org.eclipse.incquery.examples.cps.performance.tests

import java.util.Random
import org.eclipse.incquery.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.config.TransformationType
import org.eclipse.incquery.examples.cps.performance.tests.config.cases.BenchmarkCase
import org.eclipse.incquery.examples.cps.performance.tests.config.scenarios.BasicXformScenario

abstract class BasicXformTest extends PropertiesBasedTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	new(TransformationType wrapperType,	int scale, GeneratorType generatorType) {
    	this(wrapperType, scale, generatorType,1)
	}
	
	override getScenario(int scale, Random rand) {
		return new BasicXformScenario(getCase(scale, rand))
	}
	
	def BenchmarkCase getCase(int scale, Random rand)
	
}