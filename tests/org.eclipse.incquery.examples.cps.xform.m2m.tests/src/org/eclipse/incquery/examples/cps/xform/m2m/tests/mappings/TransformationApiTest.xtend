package org.eclipse.incquery.examples.cps.xform.m2m.tests.mappings

import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.*

@RunWith(Parameterized)
class TransformationApiTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper) {
		super(wrapper)
	}
	
	@Test(expected = NullPointerException)
	def noMapping() {
		val testId = "noMapping"
		info("START TEST: " + testId)
		
		initializeTransformation(null)
		
		info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullCPS() {
		val testId = "nullCPS"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.cps = null
		initializeTransformation(cps2dep)
		
		info("END TEST: " + testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullDeployment() {
		val testId = "nullDeployment"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.deployment = null
		initializeTransformation(cps2dep)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def emptyModel() {
		val testId = "emptyModel"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		initializeTransformation(cps2dep)
		executeTransformation
		
		assertTrue("Empty model modified (traces added)", cps2dep.traces.empty)
		
		info("END TEST: " + testId)
	}
	

}