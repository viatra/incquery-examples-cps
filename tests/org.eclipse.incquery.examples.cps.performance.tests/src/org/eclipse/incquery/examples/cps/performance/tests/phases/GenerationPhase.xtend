package org.eclipse.incquery.examples.cps.performance.tests.phases

import eu.mondo.sam.core.phases.AtomicPhase;
import eu.mondo.sam.core.DataToken;
import eu.mondo.sam.core.results.PhaseResult;
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.metrics.MemoryMetric

class GenerationPhase extends AtomicPhase{
	
	extension CPSModelBuilderUtil modelBuilder
	
	new(String name) {
		super(name)
		modelBuilder = new CPSModelBuilderUtil
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val generatorTimer = new TimeMetric("Time")
		val generatorMemory = new MemoryMetric("Memory")
		
		val cps2dep = preparePersistedCPSModel(cpsToken.instancesDirPath + "/" + cpsToken.scenarioName, 
			cpsToken.xform.class.simpleName + cpsToken.size + "_"+System.nanoTime
			)
		
		val CPSGeneratorInput input = new CPSGeneratorInput(cpsToken.seed, cpsToken.constraints, cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		// Generating
		generatorTimer.startMeasure
		var fragment = generator.process(plan, input);
		generatorTimer.stopMeasure
		generatorMemory.measure
		
		val engine = AdvancedIncQueryEngine.from(fragment.engine)
		Validation.instance.prepare(engine);
		val cpsStats = StatsUtil.generateStatsForCPS(engine, fragment.modelRoot)
		cpsStats.log
		engine.dispose
		
		cpsToken.cps2dep = cps2dep
		phaseResult.addMetrics(generatorTimer, generatorMemory)
	}
	
}