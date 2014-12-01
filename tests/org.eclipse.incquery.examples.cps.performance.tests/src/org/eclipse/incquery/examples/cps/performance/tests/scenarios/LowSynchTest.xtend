package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import java.util.Random
import org.eclipse.incquery.examples.cps.performance.tests.benchmark.BenchmarkResult
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper

class LowSynchTest extends BasicScenarioXformTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override getScenario(Random rand) {
		new LowSynchScenario(rand)
	}
	
	override getModificationLabel() {
		"NONE"
	}
	
	override firstModification(CPSToDeployment cps2dep, BenchmarkResult result){
		
	}
	
	
	override secondModification(CPSToDeployment cps2dep, BenchmarkResult result){
		
	}
}