package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.junit.Test

import static org.junit.Assert.*

class HostMappingTest extends CPS2DepTest {
	
	@Test
	def singleHost() {
		val testId = "singleHost"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val instance = cps2dep.prepareHostInstance
		cps2dep.executeTransformation
		
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
		cps2dep.executeTransformation
		val instance = cps2dep.prepareHostInstance
		
		cps2dep.assertHostMapping(instance)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def deleteHost() {
		val testId = "deleteHost"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val host = cps2dep.createHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val instance = host.createHostInstanceWithIP("single.cps.host.instance", ip)
		
		executeTransformation(cps2dep)
		
		info("Removing host instance from model")
		host.instances -= instance

		assertTrue("Host not removed from deployment", cps2dep.deployment.hosts.empty)
		assertTrue("Trace not removed", cps2dep.traces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def changeHostIp() {
		val testId = "changeHostIp"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val host = cps2dep.createHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val instance = host.createHostInstanceWithIP("single.cps.host.instance", ip)
		
		executeTransformation(cps2dep)
		
		info("Changing host IP")
		instance.nodeIp = "1.1.1.2"

		assertTrue("Host IP not changed in deployment", cps2dep.deployment.hosts.head.ip == instance.nodeIp)
		
		info("END TEST: " + testId)
	}
}