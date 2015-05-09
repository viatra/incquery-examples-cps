package org.eclipse.incquery.examples.cps.performance.tests.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.emf.EMFScope

class StatisticsBasedModificationPhase extends AtomicPhase{
	
	extension CPSModelBuilderUtil modelBuilder
	
	new(String name) {
		super(name)
		modelBuilder = new CPSModelBuilderUtil
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cpsToken.cps2dep))
		val changeMonitor = new DeploymentChangeMonitor(cpsToken.cps2dep.deployment, engine)
		cpsToken.changeMonitor = changeMonitor
		changeMonitor.startMonitoring

		val appType = cpsToken.cps2dep.cps.appTypes.findFirst[it.id.contains("AC_withStateMachine")]
		val hostInstance = cpsToken.cps2dep.cps.hostTypes.findFirst[it.id.contains("HC_appContainer")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		
		
	}
	
}