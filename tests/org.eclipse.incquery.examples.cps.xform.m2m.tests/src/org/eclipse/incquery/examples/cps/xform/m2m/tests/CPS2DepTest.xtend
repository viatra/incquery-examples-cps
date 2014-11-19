package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.util.PropertiesUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchSimple
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.junit.After
import org.junit.BeforeClass
import org.junit.runners.Parameterized.Parameters

class CPS2DepTest {

	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	protected extension CPSTransformationWrapper xform
	protected extension CPSModelBuilderUtil modelBuilder
	
	String wrapperType
	
	@Parameters(name = "{index}: {1}")
    public static def transformations() {
        #[
        	#[new BatchSimple(), "BatchSimple"].toArray
        	,#[new BatchIncQuery(), "BatchIncQuery"].toArray
        	,#[new ExplicitTraceability(), "ExplicitTraceability"].toArray
        ]
    }
    
    new(CPSTransformationWrapper wrapper, String wrapperType){
    	xform = wrapper
    	modelBuilder = new CPSModelBuilderUtil
    	this.wrapperType = wrapperType
    }
    
    def startTest(String testId){
    	info('''START TEST: type: «wrapperType» ID: «testId»''')
    }
    
    def endTest(String testId){
    	info('''END TEST: type: «wrapperType» ID: «testId»''')
    }
	
	@BeforeClass
	def static setupRootLogger() {
		Logger.getLogger("cps.xform").level = PropertiesUtil.getCPSXformLogLevel
		Logger.getLogger("org.eclipse.incquery").level = PropertiesUtil.getIncQueryLogLevel
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
