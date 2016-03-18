package org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers

import org.apache.log4j.Logger
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.tests.CPSTestBase
import org.eclipse.viatra.examples.cps.xform.m2m.incr.expl.CPS2DeploymentTransformation
import org.junit.Test

class WrapperTest extends CPSTestBase {
	protected extension Logger logger = Logger.getLogger("cps.xform.WrapperTest")
	
	@Test(expected = IllegalArgumentException)
	def explicitTraceabilityNullEngine() {
		
		val testId = "explicitTraceabilityNullEngine"
		info("START TEST: " + testId)
		
		val xform = new CPS2DeploymentTransformation
		val cps2dep = new CPSModelBuilderUtil().prepareEmptyModel(testId)
		xform.initialize(cps2dep, null)
		
		info("END TEST: " + testId)
	}
	
}
