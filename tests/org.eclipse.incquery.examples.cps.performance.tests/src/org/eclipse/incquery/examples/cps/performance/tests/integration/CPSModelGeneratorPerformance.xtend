package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableList
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.ClientServerScenario
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.LowSynchScenario
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.PublishSubscribeScenario
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.SimpleScalingScenario
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.junit.Test
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.tests.CPSTestBase

class CPSModelGeneratorPerformance extends CPSTestBase{
	val seed = 11111
	val D = ModelStats.DELIMITER
	
	protected extension Logger logger = Logger.getLogger("cps.performance.generator.Tests")
	
	@Test
	def scenarios(){
		
		val Random rand = new Random(seed);
		
		//(LowSynch, SimpleScaling, ClientServer, PublishSubscribe)
		val scenarios = ImmutableList.builder
	        .add(new LowSynchScenario(rand))
			.add(new SimpleScalingScenario(rand))
        	.add(new ClientServerScenario(rand))
        	.add(new PublishSubscribeScenario(rand))
			.build
			
		val scales = ImmutableList.builder
	        .add(1)
			.add(8)
			.add(16)
        	.add(32)
        	.add(64)
        	.add(128)
        	.add(256)
        	.add(512)
        	.add(1024)
			.build
		
		
		for(scenario : scenarios){
			for(scale : scales){
				val const = scenario.getConstraintsFor(scale);
				
				val generTime = Stopwatch.createStarted
				val out =  generate(const, seed)
				generTime.stop
				val IncQueryEngine engine = IncQueryEngine.on(out.modelRoot);
				Validation.instance.prepare(engine);
				val stats = StatsUtil.generateStatsForCPS(engine, out.modelRoot)

				info(scenario.class.simpleName + D + scale + D + stats.eObjects + D + stats.eReferences + D + generTime.elapsed(TimeUnit.MILLISECONDS))
			}
		}
	
		return;
	}
	
	def generate(ICPSConstraints constraints, int i) {
		CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints);
	}
}