package org.eclipse.incquery.examples.cps.performance.tests.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.DataToken
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken

class InitializationPhase extends AtomicPhase{
	
	new(String name) {
		super(name)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken

		// Transformation
//		transformInitTimer.startMesure
		cpsToken.xform.initializeTransformation(cpsToken.cps2dep)
//		transformInitTimer.stopMeasure
	}
	
}