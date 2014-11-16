package org.eclipse.incquery.examples.cps.xform.m2m.tests.util

import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory

class CPSModelBuilderUtil {
	
	protected extension Logger logger = Logger.getLogger("cps.xform.CPSModelBuilderUtil")
	protected extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	
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
	
	def prepareHostTypeWithId(CPSToDeployment cps2dep, String hostId) {
		info('''Adding host type (ID: «hostId») to model''')
		val host = createHostType => [
			id = hostId
		]
		cps2dep.cps.hostTypes += host
		host
	}
	
	def prepareHostInstanceWithIP(HostType host, String instanceId, String ip) {
		info('''Adding host instance (IP: «ip») to host type «host.id»''')
		val instance = createHostInstance => [
			id = instanceId
			nodeIp = ip
		]
		host.instances += instance
		instance
	}
	
	def prepareHostInstance(CPSToDeployment cps2dep) {
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val ip = "1.1.1.1"
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", ip)
		hostInstance
	}
	
	def prepareApplicationTypeWithId(CPSToDeployment cps2dep, String appId) {
		info('''Adding application type (ID: «appId») to model''')
		val appType = createApplicationType => [
			id = appId
		]
		cps2dep.cps.appTypes += appType
		appType
	}
	
	def prepareApplicationInstanceWithId(ApplicationType app, String appId, HostInstance host) {
		info('''Adding application instance (ID: «appId») to «app.id»''')
		val instance = createApplicationInstance => [
			id = appId
			allocatedTo = host
		]
		app.instances += instance
		instance
	}

	def prepareAppInstance(CPSToDeployment cps2dep, HostInstance hostInstance) {
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val instance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		instance
	}
	
	def prepareStateMachine(ApplicationType app, String smId) {
		info('''Adding state machine (ID: «smId») to «app.id»''')
		val instance = createStateMachine => [
			id = smId
		]
		app.behavior = instance
		instance
	}
	
	def prepareState(StateMachine sm, String stateId) {
		info('''Adding state (ID: «stateId») to «sm.id»''')
		val state = createState => [
			id = stateId
		]
		sm.states += state
		state
	}
	
	def prepareTransition(State source, String trID, State target) {
		info('''Adding transition (ID: «trID») between «source.id» and «target.id»''')
		val transition = source.prepareTransition(trID)
		transition.targetState = target
		transition
	}
	
	def prepareTransition(State source, String trID) {
		val transition = createTransition => [
			id = trID
		]
		source.outgoingTransitions += transition
		transition
	}
}