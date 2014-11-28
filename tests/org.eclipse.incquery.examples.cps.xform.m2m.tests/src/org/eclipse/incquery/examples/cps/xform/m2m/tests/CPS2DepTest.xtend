package org.eclipse.incquery.examples.cps.xform.m2m.tests

import com.google.common.collect.ImmutableList
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchOptimized
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchSimple
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.QueryResultTraceability
import org.junit.After
import org.junit.runners.Parameterized.Parameters

class CPS2DepTest extends CPSTestBase {

	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	protected extension CPSTransformationWrapper xform
	protected extension CPSModelBuilderUtil modelBuilder
	
	String wrapperType
	
	@Parameters(name = "{index}: {1}")
    public static def transformations() {
        
        /*
         * Do not alter this list other than adding new alternatives
         * or permanently removing them.
         * 
         * Use properties file to disable alternatives!
         */
        val alternatives = ImmutableList.builder
	        .add(new BatchSimple())
			.add(new BatchOptimized())
        	.add(new BatchIncQuery())
        	.add(new QueryResultTraceability())
			.add(new ExplicitTraceability())
			.build
		
		val disabled = PropertiesUtil.getDisabledM2MTransformations
		alternatives.filter[!disabled.contains(it.class.simpleName)].map[
			val simpleName = it.class.simpleName
			#[it, simpleName].toArray
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
	
	@After
	def cleanup() {
		cleanupTransformation;
		
		(0..4).forEach[Runtime.getRuntime().gc()]
	}
}
