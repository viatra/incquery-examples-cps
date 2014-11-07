package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.junit.Test
import org.apache.log4j.Level
import org.eclipse.incquery.examples.cps.xform.m2m.CPS2DeploymentTransformation

class CPS2DepTest {
	
	val logger = Logger.getLogger(typeof(CPS2DepTest))
	val cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	val depFactory = DeploymentFactory.eINSTANCE
	val traceFactory = TraceabilityFactory.eINSTANCE
	
	@Test
	def emptyModel() {
		logger.setLevel(Level.INFO)
		
		logger.info("START TEST: empty model")
		
		val rs = new ResourceSetImpl()
		val cpsRes = rs.createResource(URI.createURI("dummyCPSUri"))
		val depRes = rs.createResource(URI.createURI("dummyDeploymentUri"))
		val trcRes = rs.createResource(URI.createURI("dummyTraceabilityUri"))
		
		val cps = cpsFactory.createCyberPhysicalSystem => [
			id = "Empty CPS model"
		]
		cpsRes.contents += cps
		
		val dep = depFactory.createDeployment
		depRes.contents += dep
		 
		val cps2dep = traceFactory.createCPSToDeployment => [
			it.cps = cps
			it.deployment = dep
		]
		trcRes.contents += cps2dep
		
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep)
		
		logger.info("END TEST: empty model")
	}
	
}