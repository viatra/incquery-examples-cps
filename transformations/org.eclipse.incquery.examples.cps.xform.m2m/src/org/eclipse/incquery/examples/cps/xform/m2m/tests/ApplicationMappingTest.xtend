package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.junit.Test

import static org.junit.Assert.*

class ApplicationMappingTest extends CPS2DepTest {
	
	@Test
	def singleApplication() {
		val testId = "singleApplication"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		cps2dep.executeTransformation
		
		cps2dep.assertApplicationMapping(instance)
		
		logger.info("END TEST: " + testId)
	}
	
	def assertApplicationMapping(CPSToDeployment cps2dep, ApplicationInstance instance) {
		val applications = cps2dep.deployment.hosts.head.applications
		assertFalse("Application not transformed", applications.empty)
		val traces = cps2dep.traces
		assertEquals("Trace not created", 2, traces.size)
		val lastTrace = traces.last
		assertEquals("Trace is not complete (cpsElements)", #[instance], lastTrace.cpsElements)
		assertEquals("Trace is not complete (depElements)", applications, lastTrace.deploymentElements)
		assertEquals("ID not copied", instance.id, applications.head.id)
	}
	
	@Test
	def applicationIncremental() {
		val testId = "applicationIncremental"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		cps2dep.executeTransformation
		val instance = cps2dep.prepareAppInstance(hostInstance)
		
		cps2dep.assertApplicationMapping(instance)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationFromType() {
		val testId = "removeApplicationFromType"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		cps2dep.executeTransformation
		
		logger.info("Removing application instance from model")
		instance.type.instances -= instance

		val applications = cps2dep.deployment.hosts.head.applications
		assertTrue("Application not removed from deployment", applications.empty)
		assertEquals("Trace not removed", 1, cps2dep.traces.size)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def deallocateApplication() {
		val testId = "deallocateApplication"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		cps2dep.executeTransformation
		
		logger.info("Removing application instance from model")
		hostInstance.applications -= instance

		val applications = cps2dep.deployment.hosts.head.applications
		assertTrue("Application not removed from deployment", applications.empty)
		assertEquals("Trace not removed", 1, cps2dep.traces.size)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def reallocateApplication() {
		val testId = "reallocateApplication"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		cps2dep.executeTransformation
		
		val host = cps2dep.createHostTypeWithId("single.cps.host2")
		val hostInstance2 = host.createHostInstanceWithIP("single.cps.host2.instance", "1.1.1.2")
		logger.info("Reallocating application instance to host2")
		hostInstance2.applications += instance

		val applications = cps2dep.deployment.hosts.head.applications
		assertTrue("Application not moved from host in deployment", applications.empty)
		val applications2 = cps2dep.deployment.hosts.last.applications
		assertFalse("Application not moved to host2 in deployment", applications2.empty)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def changeApplicationId() {
		val testId = "changeApplicationId"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val instance = cps2dep.prepareAppInstance(hostInstance)
		cps2dep.executeTransformation
		
		logger.info("Changing host IP")
		instance.id = "simple.cps.app.instance2"

		val applications = cps2dep.deployment.hosts.head.applications
		assertEquals("Application ID not changed in deployment", instance.id, applications.head.id)
		
		logger.info("END TEST: " + testId)
	}
}