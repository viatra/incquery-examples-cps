package org.eclipse.incquery.examples.cps.xform.m2m.tests.integration

import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.util.PropertiesUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

@RunWith(Parameterized)
class InstanceModelTest extends CPS2DepTest {
	
	val instancesDirPath = "file://" + PropertiesUtil.getGitCloneLocation + "/models/org.eclipse.incquery.examples.cps.instances/"
		
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	@Ignore
	@Test
	def specificInputModel(){
		val testId = "specificInputModel"
		startTest(testId)
		
		val cpsUri = instancesDirPath+"example.cyberphysicalsystem"
		
		val cps2dep = prepareCPSModel(cpsUri)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		endTest(testId)
	}
	
//	@Ignore
	@Test
	def generatedDemoModel(){
		val testId = "generatedDemoModel"
		startTest(testId)
		
		val cpsUri = instancesDirPath+"generated/generatedDemoModel.cyberphysicalsystem"
		
		val cps2dep = prepareCPSModel(cpsUri)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		val appType = cps2dep.cps.appTypes.head
		val hostInstance = cps2dep.cps.hostTypes.head.instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		executeTransformation

		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
		executeTransformation

		endTest(testId)
	}
	
//	@Ignore
	@Test
	def generatedBigModel(){
		val testId = "generatedBigModel"
		startTest(testId)
		
		val cpsUri = instancesDirPath+"generated/AT60_AI2343_HT94_HI4166_S2015_T1253_AA1433_CH4166.cyberphysicalsystem"
		
		val cps2dep = prepareCPSModel(cpsUri)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		val appType = cps2dep.cps.appTypes.head
		val hostInstance = cps2dep.cps.hostTypes.head.instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		executeTransformation

		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
		executeTransformation

		endTest(testId)
	}
	
}
