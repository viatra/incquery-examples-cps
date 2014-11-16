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

		cps2dep.assertNoTrigger(transition)

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

		cps2dep.assertNoTrigger(transition)

		info("END TEST: " + testId)
	}
	
	@Test
	def sendWithMultipleWait() {
		val testId = "sendWithMultipleWait"
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
		val ip2 = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip2)
		hostInstance.communicateWith += hostInstance2

		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		val source3 = sm2.prepareState("simple.cps.sm2.s3")
		val target3 = sm2.prepareState("simple.cps.sm2.s4")
		val transition3 = source3.prepareTransition("simple.cps.sm2.t2", target3)
		transition3.action = "waitForSignal(msgId)"
		
		cps2dep.initializeTransformation
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(transition2)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		val waitTrace3 = cps2dep.traces.findFirst[cpsElements.contains(transition3)]
		assertFalse("Wait transition not transformed", waitTrace3.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements.head as BehaviorTransition
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		val depWait3 = waitTrace3.deploymentElements.head as BehaviorTransition
		assertEquals("Trigger incorrect (size)", 2, depSend.trigger.size)
		assertTrue("Trigger incorrect (depWait)", depSend.trigger.contains(depWait))
		assertTrue("Trigger incorrect (depWait3)", depSend.trigger.contains(depWait3))

		info("END TEST: " + testId)
	}
	
	@Test
	def removeSendActionOfTransition() {
		val testId = "removeSendActionOfTransition"
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
		
		info("Removing send action")
		transition.action = null
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)

		info("END TEST: " + testId)
	}
	
	@Test
	def removeLastWaitTransition() {
		val testId = "removeLastWaitTransition"
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
		
		info("Removing wait transition")
		source2.outgoingTransitions -= transition2
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)

		info("END TEST: " + testId)
	}
	
	def assertNoTrigger(CPSToDeployment cps2dep, Transition transition) {
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val depTransition = sendTrace.deploymentElements.head as BehaviorTransition
		assertTrue("Transition trigger is not empty", depTransition.trigger.empty)
	}
	
	@Test
	def removeWaitTransitionFromMultiple() {
		val testId = "removeWaitTransitionFromMultiple"
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
		val ip2 = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip2)
		hostInstance.communicateWith += hostInstance2

		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		val source3 = sm2.prepareState("simple.cps.sm2.s3")
		val target3 = sm2.prepareState("simple.cps.sm2.s4")
		val transition3 = source3.prepareTransition("simple.cps.sm2.t2", target3)
		transition3.action = "waitForSignal(msgId)"
		
		cps2dep.initializeTransformation
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(transition2)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		val waitTrace3 = cps2dep.traces.findFirst[cpsElements.contains(transition3)]
		assertFalse("Wait transition not transformed", waitTrace3.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements.head as BehaviorTransition
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		val depWait3 = waitTrace3.deploymentElements.head as BehaviorTransition
		assertEquals("Trigger incorrect (size)", 2, depSend.trigger.size)
		assertTrue("Trigger incorrect (depWait)", depSend.trigger.contains(depWait))
		assertTrue("Trigger incorrect (depWait3)", depSend.trigger.contains(depWait3))
		
		info("Removing one of two wait transitions")
		source2.outgoingTransitions -= transition2
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition3)

		info("END TEST: " + testId)
	}
	
	@Test
	def addFirstWaitTransition() {
		val testId = "addFirstWaitTransition"
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
		
		cps2dep.assertNoTrigger(transition)

		info("Adding wait transition")
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val ip2 = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip2)
		hostInstance.communicateWith += hostInstance2

		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"

		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)

		info("END TEST: " + testId)
	}
	
	@Test
	def addSecondWaitTransition() {
		val testId = "addecondWaitTransition"
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
		val ip2 = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip2)
		hostInstance.communicateWith += hostInstance2

		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		
		cps2dep.initializeTransformation
		executeTransformation

		cps2dep.assertActionMapping(transition, transition2)
		
		info("Adding second wait transition")
		val source3 = sm2.prepareState("simple.cps.sm2.s3")
		val target3 = sm2.prepareState("simple.cps.sm2.s4")
		val transition3 = source3.prepareTransition("simple.cps.sm2.t2", target3)
		transition3.action = "waitForSignal(msgId)"
		
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(transition2)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		val waitTrace3 = cps2dep.traces.findFirst[cpsElements.contains(transition3)]
		assertFalse("Wait transition not transformed", waitTrace3.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements.head as BehaviorTransition
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		val depWait3 = waitTrace3.deploymentElements.head as BehaviorTransition
		assertEquals("Trigger incorrect (size)", 2, depSend.trigger.size)
		assertTrue("Trigger incorrect (depWait)", depSend.trigger.contains(depWait))
		assertTrue("Trigger incorrect (depWait3)", depSend.trigger.contains(depWait3))
		
		info("END TEST: " + testId)
	}
	
	@Test
	def changeSendActionOfTransition() {
		val testId = "changeSendActionOfTransition"
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
		val ip2 = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip2)
		hostInstance.communicateWith += hostInstance2

		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		val source3 = sm2.prepareState("simple.cps.sm2.s3")
		val target3 = sm2.prepareState("simple.cps.sm2.s4")
		val transition3 = source3.prepareTransition("simple.cps.sm2.t2", target3)
		transition3.action = "waitForSignal(msgId2)"
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)

		info("Changing send action")
		transition.action = "sendSignal(simple.cps.app2, msgId2)"
		executeTransformation

		cps2dep.assertActionMapping(transition, transition3)

		info("END TEST: " + testId)
	}
	
	@Test
	def changeWaitActionOfTransition() {
		val testId = "changeWaitActionOfTransition"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val hostInstance = cps2dep.prepareHostInstance
		val appInstance = cps2dep.prepareAppInstance(hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
		val source2 = sm.prepareState("simple.cps.sm.s3")
		val target2 = sm.prepareState("simple.cps.sm.s4")
		val transition2 = source2.prepareTransition("simple.cps.sm.t2", target2)
		transition2.action = "sendSignal(simple.cps.app2, msgId2)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val ip2 = "1.1.1.2"
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", ip2)
		hostInstance.communicateWith += hostInstance2

		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source3 = sm2.prepareState("simple.cps.sm2.s1")
		val target3 = sm2.prepareState("simple.cps.sm2.s2")
		val transition3 = source3.prepareTransition("simple.cps.sm2.t2", target3)
		transition3.action = "waitForSignal(msgId)"
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition3)
		cps2dep.assertNoTrigger(transition2)

		info("Changing wait action")
		transition3.action = "waitForSignal(msgId2)"
		executeTransformation

		cps2dep.assertActionMapping(transition2, transition3)
		cps2dep.assertNoTrigger(transition)

		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstanceOfWait() {
		val testId = "moveApplicationInstanceOfWait"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Moving application instance for wait")
		appInstance2.allocatedTo = hostInstance
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)
		

		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstanceOfWait() {
		val testId = "removeApplicationInstanceOfWait"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Removing application instance for wait")
		app2.instances -= appInstance2
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)

		info("END TEST: " + testId)
	}
	
	@Test
	def addApplicationInstanceOfSend() {
		val testId = "addApplicationInstanceOfSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Adding application instance for send")
		app.prepareApplicationInstanceWithId("simple.cps.app.instance2", hostInstance)
		
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(transition2)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		depSend.forEach[
			val send = it as BehaviorTransition
			assertEquals("Trigger incorrect", #[depWait], send.trigger)
		]

		info("END TEST: " + testId)
	}
	
	@Test
	def moveApplicationInstanceOfSend() {
		val testId = "moveApplicationInstanceOfSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Moving application instance for send")
		appInstance.allocatedTo = hostInstance2
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeApplicationInstanceOfSend() {
		val testId = "removeApplicationInstanceOfSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Removing application instance for send")
		app.instances -= appInstance
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNull("Send transition not removed", sendTrace)

		info("END TEST: " + testId)
	}
	
	@Test
	def moveHostInstanceOfWait() {
		val testId = "moveHostInstanceOfWait"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Moving host instance for wait")
		host.instances += hostInstance2
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)

		info("END TEST: " + testId)
	}
	
	@Test
	def removeHostInstanceOfWait() {
		val testId = "removeHostInstanceOfWait"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Removing host instance for wait")
		host2.instances -= hostInstance2
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def addHostInstanceOfSend() {
		val testId = "addHostInstanceOfSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Adding host instance for send")
		val hostInstance3 = host.prepareHostInstanceWithIP("simple.cps.host.instance2", "1.1.1.3")
		hostInstance3.communicateWith += hostInstance2
		app.prepareApplicationInstanceWithId("simple.cps.app.instance2", hostInstance3)
		
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertFalse("Send transition not transformed", sendTrace.deploymentElements.empty)
		
		val waitTrace = cps2dep.traces.findFirst[cpsElements.contains(transition2)]
		assertFalse("Wait transition not transformed", waitTrace.deploymentElements.empty)
		
		val depSend = sendTrace.deploymentElements
		val depWait = waitTrace.deploymentElements.head as BehaviorTransition
		depSend.forEach[
			val send = it as BehaviorTransition
			assertEquals("Trigger incorrect", #[depWait], send.trigger)
		]

		info("END TEST: " + testId)
	}
	
	@Test
	def moveHostInstanceOfSend() {
		val testId = "moveHostInstanceOfSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Moving host instance for send")
		host2.instances += hostInstance
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)

		info("END TEST: " + testId)
	}
	
	@Test
	def removeHostInstanceOfSend() {
		val testId = "removeHostInstanceOfSend"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Removing host instance for send")
		host.instances -= hostInstance
		executeTransformation
		
		val sendTrace = cps2dep.traces.findFirst[cpsElements.contains(transition)]
		assertNull("Send transition not removed", sendTrace)

		info("END TEST: " + testId)
	}
	
	@Test
	def addHostCommunication() {
		val testId = "addHostCommunication"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)
		
		info("Adding host communication")
		hostInstance.communicateWith += hostInstance2
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def addTransitiveHostCommunication() {
		val testId = "addTransitiveHostCommunication"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)
		
		info("Adding transitive host communication")
		val hostInstance3 = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.3")
		hostInstance.communicateWith += hostInstance3
		hostInstance3.communicateWith += hostInstance2
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)
		
		info("END TEST: " + testId)
	}
	
	@Test
	def removeHostCommunication() {
		val testId = "removeHostCommunication"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
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
		
		info("Removing host communication")
		hostInstance.communicateWith -= hostInstance2
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)

		info("END TEST: " + testId)
	}
	
	@Test
	def removeTransitiveHostCommunication() {
		val testId = "removeTransitiveHostCommunication"
		info("START TEST: " + testId)
		
		val cps2dep = prepareEmptyModel(testId)
		val host = cps2dep.prepareHostTypeWithId("simple.cps.host")
		val hostInstance = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.1")
		val app = cps2dep.prepareApplicationTypeWithId("simple.cps.app")
		val appInstance = app.prepareApplicationInstanceWithId("simple.cps.app.instance", hostInstance)
		val sm = prepareStateMachine(appInstance.type, "simple.cps.sm")
		val source = sm.prepareState("simple.cps.sm.s1")
		val target = sm.prepareState("simple.cps.sm.s2")
		val transition = source.prepareTransition("simple.cps.sm.t", target)
		transition.action = "sendSignal(simple.cps.app2, msgId)"
	
		val host2 = cps2dep.prepareHostTypeWithId("simple.cps.host2")
		val hostInstance2 = host2.prepareHostInstanceWithIP("simple.cps.host2.instance", "1.1.1.2")
		val app2 = cps2dep.prepareApplicationTypeWithId("simple.cps.app2")
		val appInstance2 = app2.prepareApplicationInstanceWithId("simple.cps.app2.instance", hostInstance2)
		val sm2 = prepareStateMachine(appInstance2.type, "simple.cps.sm2")
		val source2 = sm2.prepareState("simple.cps.sm2.s1")
		val target2 = sm2.prepareState("simple.cps.sm2.s2")
		val transition2 = source2.prepareTransition("simple.cps.sm2.t", target2)
		transition2.action = "waitForSignal(msgId)"
		
		val hostInstance3 = host.prepareHostInstanceWithIP("simple.cps.host.instance", "1.1.1.3")
		hostInstance.communicateWith += hostInstance3
		hostInstance3.communicateWith += hostInstance2
		
		cps2dep.initializeTransformation
		executeTransformation
		
		cps2dep.assertActionMapping(transition, transition2)
		
		info("Removing transitive host communication")
		hostInstance3.communicateWith -= hostInstance2
		executeTransformation
		
		cps2dep.assertNoTrigger(transition)
		
		info("END TEST: " + testId)
	}
}