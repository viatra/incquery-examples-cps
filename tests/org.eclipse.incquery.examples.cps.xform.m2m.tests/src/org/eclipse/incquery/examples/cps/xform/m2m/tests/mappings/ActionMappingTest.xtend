package org.eclipse.incquery.examples.cps.xform.m2m.tests.mappings

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.*

@RunWith(Parameterized)
class ActionMappingTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper) {
		super(wrapper)
	}
	
	@Test
	def sendWithSingleWait() {
		val testId = "sendWithSingleWait"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val ip = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip)
		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		
		hostInstance.communicateWith += hostInstance2
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)

		info("END TEST: " + testId)
	}
	
	def assertActionMapping(CPSToDeployment cps2dep, Transition sendTransition, Transition waitTransition) {
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(sendTransition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(waitTransition)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements.head as BehaviorTransition
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		assertEquals("Trigger incorrect", #[depWait], depSend.trigger)
	}
	
	@Test
	def sendWithoutWait() {
		val testId = "sendWithoutWait"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		cps2dep.initializeTransformation
		executeTransformation

		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertFalse("Transitions not created", behavior.transitions.empty)
		
		val depTransition = behavior.transitions.head
		assertTrue("Transition trigger is not empty", depTransition.trigger.empty)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def waitWithoutSend() {
		val testId = "waitWithoutSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "waitForSignal(msgId)"
	
		cps2dep.initializeTransformation
		executeTransformation

		val behavior = cps2dep.deployment.hosts.head.applications.head.behavior
		assertFalse("Transitions not created", behavior.transitions.empty)
		
		val depTransition = behavior.transitions.head
		assertTrue("Transition trigger is not empty", depTransition.trigger.empty)

		info("END TEST: " + testId)
	}
	
	@Test
	def sendWithMultipleWait() {
		val testId = "sendWithMultipleWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeSend() {
		val testId = "removeSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeLastWait() {
		val testId = "removeLastWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeWaitFromMultiple() {
		val testId = "removeWaitFromMultiple"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def addFirstWait() {
		val testId = "addFirstWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def addSecondWait() {
		val testId = "addSecondWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def changeSend() {
		val testId = "changeSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def changeWait() {
		val testId = "changeWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def addApplicationInstanceOfWait() {
		val testId = "addApplicationInstanceOfWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstanceOfWait() {
		val testId = "moveApplicationInstanceOfWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstanceOfWait() {
		val testId = "removeApplicationInstanceOfWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def addApplicationInstanceOfSend() {
		val testId = "addApplicationInstanceOfSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstanceOfSend() {
		val testId = "moveApplicationInstanceOfSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstanceOfSend() {
		val testId = "removeApplicationInstanceOfSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def addHostInstanceOfWait() {
		val testId = "addHostInstanceOfWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def moveHostInstanceOfWait() {
		val testId = "moveHostInstanceOfWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeHostInstanceOfWait() {
		val testId = "removeHostInstanceOfWait"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def addHostInstanceOfSend() {
		val testId = "addHostInstanceOfSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def moveHostInstanceOfSend() {
		val testId = "moveHostInstanceOfSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def removeHostInstanceOfSend() {
		val testId = "removeHostInstanceOfSend"
		info("START TEST: " + testId)
		
		fail()

		info("END TEST: " + testId)
	}
	
	@Test
	def changeHostCommunication() {
		val testId = "changeHostCommunication"
		info("START TEST: " + testId)
		
		// TODO multiple tests!
		
		fail()

		info("END TEST: " + testId)
	}
	
	
}