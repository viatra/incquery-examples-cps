package org.eclipse.viatra.examples.cps.performance.tests

import java.util.Random
import org.eclipse.viatra.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.viatra.examples.cps.performance.tests.config.cases.PublishSubscribeCase
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.TransformationType

class BasicXformPublishSubscribeTest extends BasicXformTest {
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	override getCase(int scale, Random rand) {
		return new PublishSubscribeCase(scale, rand)
	}
	
}