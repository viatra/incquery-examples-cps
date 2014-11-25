package org.eclipse.incquery.examples.cps.xform.m2m.tests.scenarios

import java.util.Random
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper

class SimpleScalingTest extends BasicScenarioXformTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override getScenario(Random rand) {
		new SimpleScalingScenario(rand)
	}
	
}