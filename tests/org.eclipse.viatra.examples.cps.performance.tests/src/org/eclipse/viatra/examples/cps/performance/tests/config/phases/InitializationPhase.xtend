package org.eclipse.viatra.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.viatra.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine
import org.eclipse.viatra.query.runtime.emf.EMFScope

class InitializationPhase extends AtomicPhase{
	
	new(String name) {
		super(name)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val transformInitTimer = new TimeMetric("Time")
		
		transformInitTimer.startMeasure
		cpsToken.engine = AdvancedViatraQueryEngine.createUnmanagedEngine(new EMFScope(cpsToken.cps2dep.eResource.resourceSet))
		cpsToken.xform.initializeTransformation(cpsToken.cps2dep)
		transformInitTimer.stopMeasure
		
		phaseResult.addMetrics(transformInitTimer)
	}
	
}