package org.eclipse.viatra.examples.cps.tests

import org.junit.Test
import org.eclipse.viatra.query.testing.core.api.ViatraQueryTest
import org.eclipse.viatra.examples.cps.queries.util.IncreasingAlphabeticalCommunicationChainRecQuerySpecification
import org.eclipse.viatra.query.runtime.rete.matcher.ReteBackendFactory
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.viatra.examples.cps.queries.util.IncreasingAlphabeticalCommunicationChainTCQuerySpecification

class RecursionCpsTest {
	String snpRecOrig = "org.eclipse.viatra.examples.cps.queries/snapshots/test_recursion_chainRec.snapshot"
	String snpRecModified = "org.eclipse.viatra.examples.cps.queries/snapshots/test_recursion_communicationRemoved_chainRec.snapshot"
	String snpTCOrig = "org.eclipse.viatra.examples.cps.queries/snapshots/test_recursion_chainTC.snapshot"
	String snpTCModified = "org.eclipse.viatra.examples.cps.queries/snapshots/test_recursion_communicationRemoved_chainTC.snapshot"
	
	@Test
	def void staticRecursionTest() {
		ViatraQueryTest.test(IncreasingAlphabeticalCommunicationChainRecQuerySpecification.instance)
			.with(new ReteBackendFactory).with(snpRecOrig).assertEquals
	}
	
	@Test
	def void staticTransitiveClosureTest() {
		ViatraQueryTest.test(IncreasingAlphabeticalCommunicationChainTCQuerySpecification.instance)
			.with(new ReteBackendFactory).with(snpTCOrig).assertEquals
	}
	
	@Test
	def void removeCommunicationRecursionTest() {
		ViatraQueryTest.test(IncreasingAlphabeticalCommunicationChainRecQuerySpecification.instance)
			.with(new ReteBackendFactory).with(snpRecOrig).assertEqualsThen
			.modify(HostInstance, [it.identifier == "simple.cps.host.SecondHostClass0.inst1"], [ hostInst | hostInst.communicateWith.clear ])
			.with(snpRecModified).assertEquals
	}
	
	@Test
	def void removeCommunicationTransitiveClosureTest() {
		ViatraQueryTest.test(IncreasingAlphabeticalCommunicationChainTCQuerySpecification.instance)
			.with(new ReteBackendFactory).with(snpTCOrig).assertEqualsThen
			.modify(HostInstance, [it.identifier == "simple.cps.host.SecondHostClass0.inst1"], [ hostInst | hostInst.communicateWith.clear ])
			.with(snpTCModified).assertEquals
	}
}