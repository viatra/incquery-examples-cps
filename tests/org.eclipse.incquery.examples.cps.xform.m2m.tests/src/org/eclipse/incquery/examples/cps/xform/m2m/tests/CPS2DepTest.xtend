package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.junit.After
import org.junit.BeforeClass
import org.junit.runners.Parameterized.Parameters
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.Ignore

@RunWith(Parameterized)
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
		Logger.getLogger("cps.xform").level = Level.INFO
	}
	
//	@Test
//	def parameterizedRun(){
//		assertNotNull("Transformation wrapper is null", xform)
//	}

	@Ignore
	@Test
	def specificInputModel(){
		val testId = "specificInputModel"
		info("START TEST: " + testId)
		
		val cpsUri = "file://my-cps-git-location/models/org.eclipse.incquery.examples.cps.instances/example.cyberphysicalsystem"
		
		val cps2dep = prepareCPSModel(cpsUri)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		info("END TEST: " + testId)
	}
	
	@After
	def cleanup() {
		cleanupTransformation
	}
}
