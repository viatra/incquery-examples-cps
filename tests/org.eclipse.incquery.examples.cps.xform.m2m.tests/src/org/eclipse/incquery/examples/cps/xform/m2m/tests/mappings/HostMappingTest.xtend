package org.eclipse.incquery.examples.cps.xform.m2m.tests.mappings

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.*

@RunWith(Parameterized)
class HostMappingTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper) {
		super(wrapper)
	}
	
	@Test
	def singleHost() {
		val testId = "singleHost"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val instance = cps2dep.prepareHostInstance
				
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertHostMapping(instance)
		
		info("END TEST: " + testId)
	}
	
	def assertHostMapping(CPSToDeployment cps2dep, HostInstance instance) {
		val hosts = cps2dep.deployment.hosts
		assertFalse("Host not transformed", hosts.empty)
		val traces = cps2dep.traces
		assertFalse("Trace not created", traces.empty)
		val trace = traces.head
		assertEquals("Trace is not complete (cpsElements)", trace.cpsElements, #[instance])
		assertEquals("Trace is not complete (depElements)", trace.deploymentElements, hosts)
		assertEquals("IP not copied", instance.nodeIp, hosts.head.ip)
	}
	
	@Test
	def hostIncremental() {
		val testId = "hostIncremental"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
				
		cps2dep.initializeTransformation
		executeTransformation

		val instance = cps2dep.prepareHostInstance
		executeTransformation
		
		cps2dep.assertHostMapping(instance)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeHost() {
		val testId = "removeHost"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val host = cps2dep.prepareHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val instance = host.prepareHostInstanceWithIP("single.cps.host.instance", ip)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertHostMapping(instance)
		
		info("Removing host instance from model")
		host.instances -= instance
		executeTransformation

		assertTrue("Host not removed from deployment", cps2dep.deployment.hosts.empty)
		assertTrue("Trace not removed", cps2dep.traces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def changeHostIp() {
		val testId = "changeHostIp"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val host = cps2dep.prepareHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val instance = host.prepareHostInstanceWithIP("single.cps.host.instance", ip)
				
		cps2dep.initializeTransformation
		executeTransformation

		info("Changing host IP")
		instance.nodeIp = "1.1.1.2"
		executeTransformation

		assertTrue("Host IP not changed in deployment", cps2dep.deployment.hosts.head.ip == instance.nodeIp)
		
		info("END TEST: " + testId)
	}
}