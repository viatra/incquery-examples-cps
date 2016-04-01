package org.eclipse.viatra.examples.cps.tests

import java.util.Collection
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.viatra.query.testing.core.SnapshotHelper
import org.eclipse.viatra.query.testing.core.XmiModelUtil
import org.eclipse.viatra.query.testing.core.XmiModelUtil.XmiModelUtilRunningOptionEnum
import org.eclipse.viatra.query.testing.snapshot.QuerySnapshot
import org.junit.Test
import org.junit.runners.Parameterized.Parameter
import org.junit.runners.Parameterized.Parameters

import static org.junit.Assert.*

class TestingFrameworkTest {
    extension SnapshotHelper =new SnapshotHelper
    
    @Parameters(name = "{0}")
    def static Collection<Object[]> testData() {
        newArrayList(
            #[ "org.eclipse.viatra.examples.cps.instances/demo.cyberphysicalsystem" ],
            #[ "org.eclipse.viatra.examples.cps.instances/demo.cyberphysicalsystem" ]
        )
    }
    
    @Parameter(0)
    public String snp
    
    // XXX This test is meaningless because derived features has been removed from the snapshot model
    @Test
    def queryBasedFeatureTest() {
        val modelUri = XmiModelUtil::resolvePlatformURI(XmiModelUtilRunningOptionEnum.BOTH, snp)
        val rs = new ResourceSetImpl
        val snr = rs.getResource(modelUri, true)
        val qsn = snr.contents.findFirst[it instanceof QuerySnapshot] as QuerySnapshot
        qsn.matchSetRecords.forEach[
            it.matches.forEach[
                it.substitutions.forEach[
                    assertNotNull("Substitution is not correct", it.derivedValue)
                ]
            ]
        ]
    }
}