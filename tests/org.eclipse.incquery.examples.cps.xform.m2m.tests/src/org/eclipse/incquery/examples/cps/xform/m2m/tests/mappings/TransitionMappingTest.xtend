package org.eclipse.incquery.examples.cps.xform.m2m.tests.mappings

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.*
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior

@RunWith(Parameterized)
class TransitionMappingTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper) {
		super(wrapper)
	}
	
	@Test
	def singleTransition() {
		val testId = "singleTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		val transition = state.prepareTransition("simple.cps.sm.t")

		cps2dep.initializeTransformation
		executeTransformation

		cps2dep.assertTransitionMapping(transition)
		
		info("END TEST: " + testId)
	}
	
	def assertTransitionMapping(CPSToDeployment cps2dep, Transition transition) {
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertFalse("Transition not transformed", behavior.transitions.empty)
		val depTransition = behavior.transitions.head
		assertEquals("Transition not set as outgoing in source state", #[depTransition], behavior.states.head.outgoing)
		val trace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNotNull("Trace not created", trace)
		assertEquals("Trace is not complete (cpsElements)", #[transition], trace.cpsElements)
		assertEquals("Trace is not complete (depElements)", #[depTransition], trace.deploymentElements)
		assertEquals("ID not copied", transition.id, depTransition.description)
	}
	
	@Test
	def singleTransitionWithTargetState() {
		val testId = "singleTransitionWithTargetState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		
		cps2dep.initializeTransformation
		executeTransformation

		val transTraces = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNotNull("Trace not created", transTraces)
		val depTrans = transTraces.deploymentElements.head as BehaviorTransition
		val depTarget = cps2dep.traces.findFirst[cpsElements.contains(target)].deploymentElements.head as BehaviorState
		assertTrue("Target state not set", depTrans.to == depTarget)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def transitionIncremental() {
		val testId = "transitionIncremental"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")

		cps2dep.initializeTransformation
		executeTransformation

		val transition = state.prepareTransition("simple.cps.sm.t")
		executeTransformation

		cps2dep.assertTransitionMapping(transition)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def changeTransitionId() {
		val testId = "changeTransitionId"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val state = sm.prepareState("simple.cps.sm.s1")
		val transition = state.prepareTransition("simple.cps.sm.t")

		cps2dep.initializeTransformation
		executeTransformation

		info("Changing transition ID")
		transition.id = "simple.cps.sm.t2"
		executeTransformation

		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		val depTrans = behavior.transitions.head
		assertNotNull("Transition not transformed", depTrans)
		assertEquals("Id not changed in deployment", transition.id, depTrans.description)
				
		info("END TEST: " + testId)
	}
	
	@Test
	def removeTransition() {
		val testId = "removeTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertTransitionMapping(transition)

		info("Removing transition from model")
		source.outgoingTransitions -= transition
		executeTransformation
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertTrue("Transitions not removed", behavior.transitions.empty)
		val trace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNull("Trace not removed", trace)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeSourceState() {
		val testId = "removeSourceState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		
		cps2dep.initializeTransformation
		executeTransformation

		cps2dep.assertTransitionMapping(transition)

		info("Removing source state from model")
		sm.states -= source
		executeTransformation
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertTrue("Transitions not removed", behavior.transitions.empty)
		val trace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNull("Trace not removed", trace)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeTargetState() {
		val testId = "removeTargetState"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		
		cps2dep.initializeTransformation
		executeTransformation

		info("Removing target state from model")
		sm.states -= target
		executeTransformation
		
		val transTraces = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNotNull("Trace not created", transTraces)
		val depTrans = transTraces.deploymentElements.head as BehaviorTransition
		assertNull("Target state still set", depTrans.to)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def moveTransitionInsideStateMachine() {
		val testId = "moveTransitionInsideStateMachine"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val source2 = sm.prepareState("simple.cps.sm.s3")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		
		cps2dep.initializeTransformation
		executeTransformation

		cps2dep.assertTransitionMapping(transition)

		info("Moving transition to other state")
		source2.outgoingTransitions += transition
		executeTransformation
		
		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertFalse("Transitions not mapped", behavior.transitions.empty)
		val trace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNotNull("Trace not created", trace)
		val depTrans = trace.deploymentElements.head as BehaviorTransition
		assertEquals("Trace incorrect", #[depTrans], trace.deploymentElements)
		val depSource2 = behavior.states.findFirst[description == source2.id]
		assertNotNull("Second source not found", depSource2)
		assertEquals("Source state not changed", #[depTrans], depSource2.outgoing)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def addApplicationInstanceOfTransition() {
		val testId = "addApplicationInstanceOfTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
				
		cps2dep.initializeTransformation
		executeTransformation

		prepareApplicationInstanceWithId(appInstance.type, "simple.cps.app.inst2", hostInstance)
		executeTransformation
		
		val applications = cps2dep.deployment.hosts.head.applications
		applications.forEach[
			assertNotNull("State not created in deployment", it.behavior.transitions.head)
		]
		val traces = cps2dep.traces.filter[cpsElements.contains(transition)]
		assertEquals("Incorrect number of traces created", 1, traces.size)
		assertEquals("Trace is not complete (depElements)", 2, traces.head.deploymentElements.size)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstanceOfTransition() {
		val testId = "moveApplicationInstanceOfTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		
		val appType2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val sm2 = prepareStateMachine(appType2, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertTransitionMapping(transition)

		info("Moving application instance")
		appInstance.type = appType2
		executeTransformation
		
		val transTraces = cps2dep.traces.filter[cpsElements.contains(transition)]
		assertTrue("Transition not moved", transTraces.empty)
		val trans2Traces = cps2dep.traces.filter[cpsElements.contains(transition2)]
		assertFalse("Transition not moved", trans2Traces.empty)
		val depTrans = trans2Traces.head.deploymentElements.head
		val behaviorTraces = cps2dep.traces.filter[
			deploymentElements.filter(typeof(DeploymentBehavior)).exists[transitions.contains(depTrans)]
		]
		assertFalse("Transition not in app", behaviorTraces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstanceOfTransition() {
		val testId = "removeApplicationInstanceOfTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertTransitionMapping(transition)

		info("Removing instance from type")
		appInstance.type.instances -= appInstance
		executeTransformation
		
		val traces = cps2dep.traces.filter[cpsElements.contains(transition)]
		assertTrue("Trace not removed", traces.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeHostInstanceOfTransition() {
		val testId = "removeHostInstanceOfTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
				
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertTransitionMapping(transition)

		info("Deleting host instance")
		cps2dep.cps.hostTypes.head.instances -= hostInstance
		executeTransformation
		
		val traces = cps2dep.traces.filter[cpsElements.contains(transition)]
		assertTrue("Traces not removed", traces.empty)
		
		info("END TEST: " + testId)
	}
}