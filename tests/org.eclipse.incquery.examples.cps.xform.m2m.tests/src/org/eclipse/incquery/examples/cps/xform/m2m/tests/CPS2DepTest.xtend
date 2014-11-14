package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.xform.m2m.tests.util.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.junit.After
import org.junit.BeforeClass
import org.junit.runners.Parameterized.Parameters

class CPS2DepTest {

	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	protected extension CPSTransformationWrapper xform
	protected extension CPSModelBuilderUtil modelBuilder
	
	@Parameters
    public static def transformations() {
        #[
        	#[new ExplicitTraceability()].toArray
        ]
    }
    
    new(CPSTransformationWrapper wrapper){
    	xform = wrapper
    	modelBuilder = new CPSModelBuilderUtil
    }
	
	@BeforeClass
	def static setupRootLogger() {
		Logger.getLogger("cps.xform").level = Level.TRACE
	}
	
//	@Test
//	def parameterizedRun(){
//		assertNotNull("Transformation wrapper is null", xform)
//	}
	
	@After
	def cleanup() {
		cleanupTransformation
	}
}