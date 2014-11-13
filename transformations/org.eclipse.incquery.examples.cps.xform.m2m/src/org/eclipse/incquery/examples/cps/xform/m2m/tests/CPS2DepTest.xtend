package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.CPS2DeploymentTransformation
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.BeforeClass

class CPS2DepTest {

	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	protected extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	
	@BeforeClass
	def static setupRootLogger() {
		Logger.getLogger("cps.xform").level = Level.TRACE
	}
	
	def prepareEmptyModel(String cpsId) {
		val rs = new ResourceSetImpl()
		val cpsRes = rs.createResource(URI.createURI("dummyCPSUri"))
		val depRes = rs.createResource(URI.createURI("dummyDeploymentUri"))
		val trcRes = rs.createResource(URI.createURI("dummyTraceabilityUri"))
		
		val cps = createCyberPhysicalSystem => [
			id = cpsId
		]
		cpsRes.contents += cps
		
		val dep = createDeployment
		depRes.contents += dep
		 
		val cps2dep = createCPSToDeployment => [
			it.cps = cps
			it.deployment = dep
		]
		trcRes.contents += cps2dep
		cps2dep
	}
	
	def createHostTypeWithId(CPSToDeployment cps2dep, String hostId) {
		info('''Adding host type (ID: «hostId») to model''')
		val host = createHostType => [
			id = hostId
		]
		cps2dep.cps.hostTypes += host
		host
	}
	
	def createHostInstanceWithIP(HostType host, String instanceId, String ip) {
		info('''Adding host instance (IP: «ip») to host type «host.id»''')
		val instance = createHostInstance => [
			id = instanceId
			nodeIp = ip
		]
		host.instances += instance
		instance
	}
	
	def prepareHostInstance(CPSToDeployment cps2dep) {
		val host = cps2dep.createHostTypeWithId("single.cps.host")
		val ip = "1.1.1.1"
		val hostInstance = host.createHostInstanceWithIP("single.cps.host.instance", ip)
		hostInstance
	}
	
	def createApplicationTypeWithId(CPSToDeployment cps2dep, String appId) {
		info('''Adding application type (ID: «appId») to model''')
		val appType = createApplicationType => [
			id = appId
		]
		cps2dep.cps.appTypes += appType
		appType
	}
	
	def createApplicationInstanceWithId(ApplicationType app, String appId, HostInstance host) {
		info('''Adding application instance (ID: «appId») to model''')
		val instance = createApplicationInstance => [
			id = appId
			allocatedTo = host
		]
		app.instances += instance
		instance
	}

	def prepareAppInstance(CPSToDeployment cps2dep, HostInstance hostInstance) {
		val app = cps2dep.createApplicationTypeWithId("single.cps.app")
		val instance = app.createApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		instance
	}
	
	def prepareStateMachine(ApplicationType app, String smId) {
		val instance = createStateMachine => [
			id = smId
		]
		app.behavior = instance
		instance
	}
	
	def prepareState(StateMachine sm, String stateId) {
		val state = createState => [
			id = stateId
		]
		sm.states += state
		state
	}
	
	def executeTransformation(CPSToDeployment cps2dep) {
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		val xform = new CPS2DeploymentTransformation
		xform.execute(cps2dep, engine)
	}
	
}