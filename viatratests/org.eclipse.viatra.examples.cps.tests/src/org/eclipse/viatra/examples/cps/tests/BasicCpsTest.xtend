package org.eclipse.viatra.examples.cps.tests

import org.eclipse.viatra.examples.cps.queries.SimpleCpsQueries
import org.eclipse.viatra.examples.cps.queries.util.ApplicationInstancesOfApplicationTypeIdentifiersQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationInstancesOfApplicationTypeQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationInstancesQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationTypeWithHostedInstanceIdentifiersQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationTypeWithHostedInstancesQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationTypeWithoutHostedInstanceIdentifiersQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationTypeWithoutHostedInstanceQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.ApplicationTypesQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.CommunicateWithQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.FinalPatternQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HasMoreCommunicationPartnerQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HasMoreHostedApplicationInstancesQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HasMoreHostedApplicationsQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HasTheMostCommunicationPartnerQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HasTheMostHostedApplicationInstancesQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HasTheMostHostedApplicationsQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HostInstanceWithAtLeastAsMuchTotalRamAsTotalHddQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HostInstanceWithPrimeTotalRamQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HostInstancesWithZeroTotalRamQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.HostedApplicationsQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.InTheCommunicationChainsQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.InstancesQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.TransitionsOfApplicationTypeIdentifiersQuerySpecification
import org.eclipse.viatra.examples.cps.queries.util.TransitionsOfApplicationTypeQuerySpecification
import org.eclipse.viatra.query.runtime.api.IPatternMatch
import org.eclipse.viatra.query.runtime.api.IQuerySpecification
import org.eclipse.viatra.query.runtime.api.ViatraQueryMatcher
import org.eclipse.viatra.query.runtime.rete.matcher.ReteBackendFactory
import org.eclipse.viatra.query.testing.core.api.ViatraQueryTest
import org.junit.Test
import org.eclipse.viatra.query.runtime.localsearch.matcher.integration.LocalSearchBackendFactory

class BasicCpsTest {
	
	val snapshot = "org.eclipse.viatra.examples.cps.queries/snapshots/test.snapshot"
	
	@Test
	def void testAllQueries() {
		SimpleCpsQueries.instance.specifications.forEach[
			ViatraQueryTest.test(it as IQuerySpecification<ViatraQueryMatcher<IPatternMatch>>)
				.with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals
		]
	}
	
	@Test def void testApplicationTypes() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationTypes").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationInstances() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationInstances").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationInstancesOfApplicationType() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationInstancesOfApplicationType").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationInstancesOfApplicationTypeIdentifiers() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationInstancesOfApplicationTypeIdentifiers").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationTypeWithHostedInstances() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationTypeWithHostedInstances").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationTypeWithHostedInstanceIdentifiers() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationTypeWithHostedInstanceIdentifiers").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationTypeWithoutHostedInstance() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationTypeWithoutHostedInstance").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testApplicationTypeWithoutHostedInstanceIdentifiers() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.applicationTypeWithoutHostedInstanceIdentifiers").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testTransitionsOfApplicationType() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.transitionsOfApplicationType").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testTransitionsOfApplicationTypeIdentifiers() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.transitionsOfApplicationTypeIdentifiers").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHostInstancesWithZeroTotalRam() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hostInstancesWithZeroTotalRam").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHostInstanceWithAtLeastAsMuchTotalRamAsTotalHdd() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hostInstanceWithAtLeastAsMuchTotalRamAsTotalHdd").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHostInstanceWithPrimeTotalRam() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hostInstanceWithPrimeTotalRam").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	// This is necessary because of 490761 bug
	@Test def void testHasMoreHostedApplicationInstances() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hasMoreHostedApplicationInstances").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	// This is necessary because of 490761 bug
	@Test def void testHasTheMostHostedApplicationInstances() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hasTheMostHostedApplicationInstances").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testCommunicateWith() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.communicateWith").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testInTheCommunicationChains() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.inTheCommunicationChains").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHasMoreCommunicationPartner() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hasMoreCommunicationPartner").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHasTheMostCommunicationPartner() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hasTheMostCommunicationPartner").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHostedApplications() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hostedApplications").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHasMoreHostedApplications() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hasMoreHostedApplications").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testHasTheMostHostedApplications() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.hasTheMostHostedApplications").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testFinalPattern() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.finalPattern").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void testInstances() { ViatraQueryTest.test("org.eclipse.viatra.examples.cps.queries.instances").with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	
	@Test def void mfTestApplicationTypes() { ViatraQueryTest.test(ApplicationTypesQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationInstances() { ViatraQueryTest.test(ApplicationInstancesQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationInstancesOfApplicationType() { ViatraQueryTest.test(ApplicationInstancesOfApplicationTypeQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationInstancesOfApplicationTypeIdentifiers() { ViatraQueryTest.test(ApplicationInstancesOfApplicationTypeIdentifiersQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationTypeWithHostedInstances() { ViatraQueryTest.test(ApplicationTypeWithHostedInstancesQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationTypeWithHostedInstanceIdentifiers() { ViatraQueryTest.test(ApplicationTypeWithHostedInstanceIdentifiersQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationTypeWithoutHostedInstance() { ViatraQueryTest.test(ApplicationTypeWithoutHostedInstanceQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestApplicationTypeWithoutHostedInstanceIdentifiers() { ViatraQueryTest.test(ApplicationTypeWithoutHostedInstanceIdentifiersQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestTransitionsOfApplicationType() { ViatraQueryTest.test(TransitionsOfApplicationTypeQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestTransitionsOfApplicationTypeIdentifiers() { ViatraQueryTest.test(TransitionsOfApplicationTypeIdentifiersQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHostInstancesWithZeroTotalRam() { ViatraQueryTest.test(HostInstancesWithZeroTotalRamQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHostInstanceWithAtLeastAsMuchTotalRamAsTotalHdd() { ViatraQueryTest.test(HostInstanceWithAtLeastAsMuchTotalRamAsTotalHddQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHostInstanceWithPrimeTotalRam() { ViatraQueryTest.test(HostInstanceWithPrimeTotalRamQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHasMoreHostedApplicationInstances() { ViatraQueryTest.test(HasMoreHostedApplicationInstancesQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHasTheMostHostedApplicationInstances() { ViatraQueryTest.test(HasTheMostHostedApplicationInstancesQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestCommunicateWith() { ViatraQueryTest.test(CommunicateWithQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestInTheCommunicationChains() { ViatraQueryTest.test(InTheCommunicationChainsQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHasMoreCommunicationPartner() { ViatraQueryTest.test(HasMoreCommunicationPartnerQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHasTheMostCommunicationPartner() { ViatraQueryTest.test(HasTheMostCommunicationPartnerQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHostedApplications() { ViatraQueryTest.test(HostedApplicationsQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHasMoreHostedApplications() { ViatraQueryTest.test(HasMoreHostedApplicationsQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestHasTheMostHostedApplications() { ViatraQueryTest.test(HasTheMostHostedApplicationsQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestFinalPattern() { ViatraQueryTest.test(FinalPatternQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	@Test def void mfTestInstances() { ViatraQueryTest.test(InstancesQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals }
	
	@Test
	def void wildCardTestFinalPattern() {
		ViatraQueryTest.test(FinalPatternQuerySpecification.instance).with(snapshot).with(new ReteBackendFactory).with(LocalSearchBackendFactory.INSTANCE).assertEquals
	}
}
