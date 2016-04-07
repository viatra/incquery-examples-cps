package org.eclipse.viatra.examples.cps.tests

import java.util.Collection
import org.eclipse.viatra.examples.cps.tests.queries.util.SameVariablesQuerySpecification
import org.eclipse.viatra.query.testing.core.XmiModelUtil
import org.eclipse.viatra.query.testing.core.XmiModelUtil.XmiModelUtilRunningOptionEnum
import org.eclipse.viatra.query.testing.core.api.ViatraQueryTest
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameter
import org.junit.runners.Parameterized.Parameters

// This test is necessary because of 481263 and 491248 bugs
@RunWith(Parameterized)
class VariableEqualityCpsTest {
    @Parameters(name = "Model: {0}")
    def static Collection<Object[]> testData() {
        newArrayList(
            #[ 
                "org.eclipse.viatra.examples.cps.tests.instances/demo.cyberphysicalsystem"
            ]
        )
    }
    
    @Parameter(0)
    public String modelPath
    
    
    @Test
    def void variableEqualityTest() {
        ViatraQueryTest.test(SameVariablesQuerySpecification.instance)
                        .on(XmiModelUtil::resolvePlatformURI(XmiModelUtilRunningOptionEnum.BOTH, modelPath))
                        .with(BackendType.Rete.newBackendInstance)
                        .with(BackendType.LocalSearch.newBackendInstance)
                        .assertEquals
    }
}