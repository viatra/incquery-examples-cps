package org.eclipse.viatra.examples.cps.xform.m2m.tests.mappings

import org.eclipse.viatra.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.*

@RunWith(Parameterized)
class TransformationApiTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	@Test(expected = NullPointerException)
	def noMapping() {
		val testId = "noMapping"
		startTest(testId)
		
		initializeTransformation(null)
		
		endTest(testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullCPS() {
		val testId = "nullCPS"
		startTest(testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.cps = null
		initializeTransformation(cps2dep)
		
		endTest(testId)
	}
	
	@Test(expected = IllegalArgumentException)
	def nullDeployment() {
		val testId = "nullDeployment"
		startTest(testId)
		
		val cps2dep = prepareEmptyModel(testId)
		cps2dep.deployment = null
		initializeTransformation(cps2dep)
		
		endTest(testId)
	}
	
	@Test
	def emptyModel() {
		val testId = "emptyModel"
		startTest(testId)
		
		val cps2dep = prepareEmptyModel(testId)
		initializeTransformation(cps2dep)
		executeTransformation
		
		assertTrue("Empty model modified (traces added)", cps2dep.traces.empty)
		
		endTest(testId)
	}
	

}