package org.eclipse.incquery.examples.cps.performance.tests.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.DataToken
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil

class GenerationPhase extends AtomicPhase{
	
	extension CPSModelBuilderUtil modelBuilder
	
	new(String name) {
		super(name)
		modelBuilder = new CPSModelBuilderUtil
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		
		val cps2dep = preparePersistedCPSModel(cpsToken.instancesDirPath + "/" + cpsToken.scenarioName, 
			cpsToken.xform.class.simpleName + cpsToken.size + "_"+System.nanoTime
			)
		
		val CPSGeneratorInput input = new CPSGeneratorInput(cpsToken.seed, cpsToken.constraints, cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		// Generating
//		generatorTimer.startMesure
		var fragment = generator.process(plan, input);
//		generatorTimer.stopMeasure
		
		val engine = AdvancedIncQueryEngine.from(fragment.engine)
		Validation.instance.prepare(engine);
		val cpsStats = StatsUtil.generateStatsForCPS(engine, fragment.modelRoot)
//		result.artifactSize = cpsStats.eObjects
		cpsStats.log
		engine.dispose
		
		cpsToken.cps2dep = cps2dep
//		info("Generating time: " + generatorTimer.getValue + " ms")
//		val long generateMemory = QueryRegressionTest.logMemoryProperties
	}
	
}