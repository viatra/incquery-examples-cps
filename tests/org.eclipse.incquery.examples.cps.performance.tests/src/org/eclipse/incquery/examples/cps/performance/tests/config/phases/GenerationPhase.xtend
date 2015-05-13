package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor

class GenerationPhase extends AtomicPhase{
	
	ICPSConstraints constraints
	
	new(String name, ICPSConstraints constraints) {
		super(name)
		this.constraints = constraints
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val generatorTimer = new TimeMetric("Time")
		val generatorMemory = new MemoryMetric("Memory")

		val CPSGeneratorInput input = new CPSGeneratorInput(cpsToken.seed, constraints, cpsToken.cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		// Generating
		generatorTimer.startMeasure
		var fragment = generator.process(plan, input);
		generatorTimer.stopMeasure
		generatorMemory.measure
		
		
		Validation.instance.prepare(fragment.engine);
		val cpsStats = StatsUtil.generateStatsForCPS(fragment.engine, fragment.modelRoot)
		cpsStats.log
		fragment.engine.dispose
		
		phaseResult.addMetrics(generatorTimer, generatorMemory)
	}
}