package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.emf.EMFScope

class ChangeMonitorInitializationPhase extends AtomicPhase {
	
	new(String phaseName) {
		super(phaseName)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cpsToken.cps2dep))
		val changeMonitor = new DeploymentChangeMonitor(cpsToken.cps2dep.deployment, engine)
		cpsToken.changeMonitor = changeMonitor
		changeMonitor.startMonitoring
	}
	
}