package org.eclipse.viatra.examples.cps.performance.tests

import java.util.Random
import org.eclipse.viatra.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.viatra.examples.cps.performance.tests.config.cases.SimpleScalingCase
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.TransformationType

class BasicXformSimpleScalingTest extends BasicXformTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	override getCase(int scale, Random rand) {
		return new SimpleScalingCase(scale, rand)
	}
	
}