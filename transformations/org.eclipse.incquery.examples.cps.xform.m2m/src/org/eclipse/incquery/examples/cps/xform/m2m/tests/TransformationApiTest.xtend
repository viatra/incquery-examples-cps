package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.xform.m2m.CPS2DeploymentTransformation
import org.junit.Test

import static org.junit.Assert.*

class TransformationApiTest extends CPS2DepTest {
	
	@Test(expected = IllegalArgumentException)
	def noMapping() {
		val testId = "noMapping"
		info("START TEST: " + testId)
		
		val xform = new CPS2DeploymentTransformation
		xform.execute(null, null)
		
		info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullCPS() {
		val testId = "nullCPS"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.cps = null
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, null)
		
		info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullDeployment() {
		val testId = "nullDeployment"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.deployment = null
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, null)
		
		info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullEngine() {
		val testId = "nullEngine"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, null)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def emptyModel() {
		val testId = "emptyModel"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		executeTransformation(cps2dep)
		
		assertTrue("Empty model modified (traces added)", cps2dep.traces.empty)
		
		info("END TEST: " + testId)
	}
	

}