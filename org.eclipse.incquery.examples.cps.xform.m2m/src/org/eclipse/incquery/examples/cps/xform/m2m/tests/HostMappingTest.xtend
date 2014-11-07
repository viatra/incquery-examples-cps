package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.xform.m2m.CPS2DeploymentTransformation
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.Test

import static org.junit.Assert.*

class HostMappingTest extends CPS2DepTest {
	
	@Test
	def transformSingleHost() {
		val testId = "transformSingleHost"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val host = createHostType => [
			id = "single.cps.host"
		]
		val ip = "1.1.1.1"
		val instance = createHostInstance => [
			id = "single.cps.hostInstance"
			nodeIp = ip
		]
		host.instances += instance
		cps2dep.cps.hostTypes += host
		
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, engine)
		
		assertFalse("Host not transformed", cps2dep.deployment.hosts.empty)
		assertFalse("Trace not created", cps2dep.traces.empty)
		assertEquals("Trace is not complete (cpsElements)", cps2dep.traces.head.cpsElements, #[instance])
		assertEquals("Trace is not complete (depElements)", cps2dep.traces.head.deploymentElements, cps2dep.deployment.hosts)
		assertTrue("IP not copied", cps2dep.deployment.hosts.head.ip == ip)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def transformHostIncremental() {
		val testId = "transformHostIncremental"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, engine)
		
		logger.info("Adding single host to model")
		val host = createHostType => [
			id = "single.cps.host"
		]
		val ip = "1.1.1.1"
		val instance = createHostInstance => [
			id = "single.cps.hostInstance"
			nodeIp = ip
		]
		host.instances += instance
		cps2dep.cps.hostTypes += host
		
		assertFalse("Host not transformed", cps2dep.deployment.hosts.empty)
		assertFalse("Trace not created", cps2dep.traces.empty)
		assertEquals("Trace is not complete (cpsElements)", cps2dep.traces.head.cpsElements, #[instance])
		assertEquals("Trace is not complete (depElements)", cps2dep.traces.head.deploymentElements, cps2dep.deployment.hosts)
		assertTrue("IP not copied", cps2dep.deployment.hosts.head.ip == ip)
		
		logger.info("END TEST: " + testId)
	}
	
	@Test
	def deleteHostIncremental() {
		val testId = "transformHostIncremental"
		logger.info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		
		val host = createHostType => [
			id = "single.cps.host"
		]
		val ip = "1.1.1.1"
		val instance = createHostInstance => [
			id = "single.cps.hostInstance"
			nodeIp = ip
		]
		host.instances += instance
		cps2dep.cps.hostTypes += host
		
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, engine)
		
		logger.info("Removing host instance from model")
		host.instances -= instance

		assertTrue("Host not removed from deployment", cps2dep.deployment.hosts.empty)
		assertTrue("Trace not removed", cps2dep.traces.empty)
		
		logger.info("END TEST: " + testId)
	}
}