package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory

class EMFResourceInitializationPhase extends AtomicPhase{
	
	protected extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	
	protected extension CPSModelBuilderUtil modelBuilderUtil = new CPSModelBuilderUtil 
	
	
	new(String phaseName) {
		super(phaseName)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val CPSDataToken cpsToken = token as CPSDataToken
		val emfInitTimer = new TimeMetric("Time")
		val emfInitMemory = new MemoryMetric("Memory")
		
		emfInitTimer.startMeasure
		cpsToken.cps2dep = preparePersistedCPSModel(cpsToken.instancesDirPath + "/" + cpsToken.scenarioName,
			cpsToken.xform.class.simpleName + cpsToken.size + "_" + System.nanoTime)
		emfInitTimer.stopMeasure
		emfInitMemory.measure
		phaseResult.addMetrics(emfInitTimer, emfInitMemory)
	}
	
}