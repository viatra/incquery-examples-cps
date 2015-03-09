package org.eclipse.incquery.examples.cps.performance.tests.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.DataToken
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken

class TransformationPhase extends AtomicPhase{
	
	new(String name) {
		super(name)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
//		transformTimer.startMesure
		val cpsToken =token as CPSDataToken 
		cpsToken.xform.executeTransformation
//		transformTimer.stopMeasure
//		info("Xform1 time: " + transformTimer.getValue + " ms");
//		result.addCheckTime(transformTime.elapsed(TimeUnit.MILLISECONDS))
		
//		val long firstTransformationMemory = QueryRegressionTest.logMemoryProperties
	}
	
}