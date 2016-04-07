package org.eclipse.viatra.examples.cps.tests

import junit.framework.AssertionFailedError
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.viatra.examples.cps.tests.queries.util.AllVariablesNamedQuerySpecification
import org.eclipse.viatra.examples.cps.tests.queries.util.AnonymousVariablesQuerySpecification
import org.eclipse.viatra.query.runtime.matchers.backend.IQueryBackendFactory
import org.eclipse.viatra.query.runtime.matchers.backend.QueryEvaluationHint
//import org.eclipse.viatra.query.testing.core.MatchSetRecordHelper
import org.eclipse.viatra.query.testing.core.PatternBasedMatchSetModelProvider
import org.junit.Test
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.junit.runners.Parameterized.Parameter
import org.junit.Before
import org.eclipse.viatra.query.testing.core.XmiModelUtil.XmiModelUtilRunningOptionEnum
import org.eclipse.viatra.query.testing.core.XmiModelUtil
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameters
import java.util.Collection
import org.eclipse.viatra.query.runtime.rete.matcher.ReteBackendFactory
import org.eclipse.viatra.query.runtime.localsearch.matcher.integration.LocalSearchBackendFactory
import org.eclipse.viatra.query.testing.core.MatchSetRecordDiff

// This test is necessary because of 398745 bug
@RunWith(Parameterized)
class AnonymousVariablesCpsTest {
    @Parameters(name = "Backend: {0}, Model: {1}")
    def static Collection<Object[]> testData() {
        newArrayList(
            #[  BackendType.Rete,
                "org.eclipse.viatra.examples.cps.tests.instances/demo.cyberphysicalsystem"
            ],
            #[  BackendType.LocalSearch,
                "org.eclipse.viatra.examples.cps.tests.instances/demo.cyberphysicalsystem"
            ]
        )
    }
    
	@Parameter(0)
	public BackendType backendType
	IQueryBackendFactory queryBackendFactory
	@Parameter(1)
	public String modelPath
	ResourceSet rs
	
	
	@Before
	def void prepareTest() {
	    queryBackendFactory = backendType.newBackendInstance
	    val modelUri = XmiModelUtil::resolvePlatformURI(XmiModelUtilRunningOptionEnum.BOTH, modelPath)
	    rs = new ResourceSetImpl
	    rs.getResource(modelUri, true)
	}

	@Test
	def void anonymousVariablesTest() {
		val hint = new QueryEvaluationHint(queryBackendFactory, emptyMap)
		val modelProvider = new PatternBasedMatchSetModelProvider(hint)
		val anonymousMatchSet = modelProvider.getMatchSetRecord(rs, AnonymousVariablesQuerySpecification.instance, null)
		val namedMatchSet = modelProvider.getMatchSetRecord(rs, AllVariablesNamedQuerySpecification.instance, null)
		val diff = MatchSetRecordDiff.compute(anonymousMatchSet, namedMatchSet)
		if (!diff.empty) {
            throw new AssertionFailedError(diff.toString)
        }
	}
}
