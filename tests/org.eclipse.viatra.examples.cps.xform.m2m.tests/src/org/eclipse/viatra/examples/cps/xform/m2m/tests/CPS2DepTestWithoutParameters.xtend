package org.eclipse.viatra.examples.cps.xform.m2m.tests

import org.apache.log4j.Logger
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.tests.CPSTestBase
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.After

class CPS2DepTestWithoutParameters extends CPSTestBase {

	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	protected extension CPSTransformationWrapper xform
	protected extension CPSModelBuilderUtil modelBuilder
	
	String wrapperType
	
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
	
	@After
	def cleanup() {
		cleanupTransformation;
		
		(0..4).forEach[Runtime.getRuntime().gc()]
	}
}
