package org.eclipse.incquery.examples.cps.performance.tests

import java.util.Random
import org.eclipse.incquery.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.config.TransformationType
import org.eclipse.incquery.examples.cps.performance.tests.config.cases.SimpleScalingCase

class BasicXformSimpleScalingTest extends BasicXformTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	new(TransformationType wrapperType,	int scale, GeneratorType generatorType) {
    	this(wrapperType, scale, generatorType,1)
	}
	
	override getCase(int scale, Random rand) {
		return new SimpleScalingCase(scale, rand)
	}
	
}