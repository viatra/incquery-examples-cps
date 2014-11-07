package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.xform.m2m.CPS2DeploymentTransformation
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.Test

import static org.junit.Assert.*

class TransformationApiTest extends CPS2DepTest {
	
	@Test(expected = IllegalArgumentException)
	def noMapping() {
		val testId = "noMapping"
		logger.info("START TEST: " + testId)
		
		val xform = new CPS2DeploymentTransformation
		xform.execute(null, null)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullCPS() {
		val testId = "nullCPS"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.cps = null
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, null)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullDeployment() {
		val testId = "nullDeployment"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.deployment = null
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, null)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullEngine() {
		val testId = "nullEngine"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, null)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def emptyModel() {
		val testId = "emptyModel"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, engine)
		
		assertTrue("Empty model modified (traces added)", cps2dep.traces.empty)
		
		logger.info("END TEST: " + testId)
	}
	

}