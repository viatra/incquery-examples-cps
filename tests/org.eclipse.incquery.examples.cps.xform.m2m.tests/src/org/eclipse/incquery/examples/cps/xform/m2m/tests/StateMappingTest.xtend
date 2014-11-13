package org.eclipse.incquery.examples.cps.xform.m2m.tests

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.junit.Test

import static org.junit.Assert.*
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior

class StateMappingTest extends CPS2DepTest {
	
	@Test
	def singleState() {
		val testId = "singleState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		cps2dep.assertStateMapping(state)
		
		info("END TEST: " + testId)
	}
	
	def assertStateMapping(CPSToDeployment cps2dep, State state) {
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertFalse("State not transformed", behavior.states.empty)
		val depState = behavior.states.head
		val trace = cps2dep.traces.findFirst[cpsElements.contains(state)]
		assertNotNull("Trace not created", trace)
		assertEquals("Trace is not complete (cpsElements)", #[state], trace.cpsElements)
		assertEquals("Trace is not complete (depElements)", #[depState], trace.deploymentElements)
		assertEquals("ID not copied", state.id, depState.description)
	}
	
	@Test
	def stateIncrmental() {
		val testId = "stateIncrmental"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		
		cps2dep.executeTransformation
		
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.assertStateMapping(state)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def initialState() {
		val testId = "initialState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		sm.initial = state
		
		cps2dep.executeTransformation
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		val trace = cps2dep.traces.findFirst[cpsElements.contains(state)]
		assertEquals("Initial property not transformed", trace.deploymentElements.head, behavior.current)
		
		info("END TEST: " + testId)
	}
		
	@Test
	def changeInitialState() {
		val testId = "changeInitialState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		sm.initial = state
		
		cps2dep.executeTransformation
		
		val state2 = sm.prepareState("simple.cps.sm.s2")
		sm.initial = state2

		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		val trace = cps2dep.traces.findFirst[cpsElements.contains(state2)]
		assertEquals("Initial property not changed", trace.deploymentElements.head, behavior.current)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def changeStateId() {
		val testId = "changeStateId"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		info("Changing state  ID.")
		state.id = "simple.cps.sm.s2"
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertEquals("Id not changed in deployment", state.id, behavior.states.head.description)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeState() {
		val testId = "removeState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		sm.states -= state
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertTrue("State not removed", behavior.states.empty)
		val trace = cps2dep.traces.findFirst[cpsElements.contains(state)]
		assertNull("Trace not removed", trace)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeInitialState() {
		val testId = "removeInitialState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		sm.initial = state
		
		cps2dep.executeTransformation
		
		sm.states -= state
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertNull("Current state not removed", behavior.current)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeStateMachineOfState() {
		val testId = "removeStateMachineOfState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		info("Removing state machine from app type.")
		appInstance.type.behavior = null
		
		val trace = cps2dep.traces.findFirst[cpsElements.contains(state)]
		assertNull("Trace not removed", trace)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def addApplicationInstanceOfState() {
		val testId = "addApplicationInstance"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		createApplicationInstanceWithId(appInstance.type, "simple.cps.app.inst2", hostInstance)
		
		val applications = cps2dep.deployment.hosts.head.applications
		applications.forEach[
			assertNotNull("State not created in deployment", it.behavior.states.head)
		]
		val traces = cps2dep.traces.filter[cpsElements.contains(state)]
		assertEquals("Incorrect number of traces created", 1, traces.size)
		assertEquals("Trace is not complete (depElements)", 2, traces.head.deploymentElements.size)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstanceOfState() {
		val testId = "removeApplicationInstance"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		info("Removing instance from type")
		appInstance.type.instances -= appInstance
		
		val traces = cps2dep.traces.filter[cpsElements.contains(state)]
		assertTrue("Trace not removed", traces.empty)

		info("END TEST: " + testId)
	}
	
	@Test
	def moveStateMachineOfState() {
		val testId = "moveStateMachine"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val appType2 = cps2dep.createApplicationTypeWithId("simple.cps.app2")
		appType2.createApplicationInstanceWithId("simple.cps.app2.instance", hostInstance)
		
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		info("Moving state machine")
		appType2.behavior = sm
		
		val traces = cps2dep.traces.filter[cpsElements.contains(state)]
		assertFalse("Trace for state does not exist", traces.empty)
		val depState = traces.head.deploymentElements.head
		val behaviorTraces = cps2dep.traces.filter[deploymentElements.filter(typeof(DeploymentBehavior)).exists[states.contains(depState)]]
		assertFalse("State not moved", behaviorTraces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstance() {
		val testId = "moveApplicationInstance"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm1.s")
		
		val appType2 = cps2dep.createApplicationTypeWithId("simple.cps.app2")
		val sm2 = prepareStateMachine(appType2, "simple.cps.sm2")
		val state2 = sm2.prepareState("simple.cps.sm2.s")
		
		cps2dep.executeTransformation
		
		info("Moving application instance")
		appInstance.type = appType2
		
		val stateTraces = cps2dep.traces.filter[cpsElements.contains(state)]
		assertTrue("State not moved", stateTraces.empty)
		val state2Traces = cps2dep.traces.filter[cpsElements.contains(state2)]
		assertFalse("State not moved", state2Traces.empty)
		val depState = state2Traces.head.deploymentElements.head
		val behaviorTraces = cps2dep.traces.filter[deploymentElements.filter(typeof(DeploymentBehavior)).exists[states.contains(depState)]]
		assertFalse("State not in app", behaviorTraces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def deleteHostInstanceOfState() {
		val testId = "deleteHostInstanceOfBehavior"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		
		cps2dep.executeTransformation
		
		info("Deleting host instance")
		cps2dep.cps.hostTypes.head.instances -= hostInstance
		
		val traces = cps2dep.traces.filter[cpsElements.contains(state)]
		assertTrue("Traces not removed", traces.empty)
		
		info("END TEST: " + testId)
	}
}