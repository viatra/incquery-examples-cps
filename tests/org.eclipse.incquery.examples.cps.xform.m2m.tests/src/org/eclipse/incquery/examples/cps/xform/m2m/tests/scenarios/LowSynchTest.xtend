package org.eclipse.incquery.examples.cps.xform.m2m.tests.scenarios

import org.eclipse.incquery.examples.cps.xform.m2m.tests.scenarios.BasicScenarioXformTest
import java.util.Random
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper

class LowSynchTest extends BasicScenarioXformTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override getScenario(Random rand) {
		new LowSynchScenario(rand)
	}
	
}