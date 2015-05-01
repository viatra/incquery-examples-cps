package org.eclipse.incquery.examples.cps.performance.tests.queries

import com.google.common.base.Stopwatch
import com.google.common.collect.Maps
import java.util.Map
import java.util.Random
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.LowSynchScenario
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.patterns.CpsXformM2M
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.api.GenericPatternGroup
import org.eclipse.incquery.runtime.api.IQueryGroup
import org.eclipse.incquery.runtime.api.IQuerySpecification
import org.junit.Test
import org.eclipse.incquery.runtime.emf.EMFScope
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.StatisticsBasedScenario

class QueryRegressionTest extends CPSTestBase{
	
	protected static extension Logger logger = Logger.getLogger("cps.xform.QueryTest")
    protected extension CPSModelBuilderUtil modelBuilder = new CPSModelBuilderUtil
	
	AdvancedIncQueryEngine incQueryEngine
	IQueryGroup queryGroup
	Map<String, Long> results = Maps.newTreeMap()
	
	public def prepare() {
		info("Preparing query performance test")
		
		val rs = executeScenarioXformForConstraints(16)
		incQueryEngine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(rs))
		queryGroup = GenericPatternGroup.of(
			CpsXformM2M.instance
		)
		queryGroup.prepare(incQueryEngine)
		debug("Base index created")
		incQueryEngine.wipe()
		debug("IncQuery engine wiped")
		logMemoryProperties
		info("Prepared query performance test")
	}
	
	def executeScenarioXformForConstraints(int size) {	
		val seed = 11111
		val Random rand = new Random(seed)
		val IScenario scenario = new StatisticsBasedScenario(rand)
		val constraints = scenario.getConstraintsFor(size)
		val cps2dep = prepareEmptyModel("testModel"+System.nanoTime)
		
		val CPSGeneratorInput input = new CPSGeneratorInput(seed, constraints, cps2dep.cps)
		var plan = CPSPlanBuilder.buildDefaultPlan
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor()
		
		var generateTime = Stopwatch.createStarted
		var fragment = generator.process(plan, input)
		generateTime.stop
		info("Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms")
		
		val engine = AdvancedIncQueryEngine.from(fragment.engine);
		Validation.instance.prepare(engine);
		
		StatsUtil.generateStatsForCPS(engine, fragment.modelRoot).log
		
		engine.dispose
		
		cps2dep.eResource.resourceSet
	}
	
	@Test
//	@Ignore
	public def queryPerformance() {
		prepare()
		
		info("Starting query performance test")
		
		for (IQuerySpecification<?> specification : queryGroup.getSpecifications) {
			
			debug("Measuring pattern " + specification.getFullyQualifiedName)
			incQueryEngine.wipe
			val usedHeapBefore = logMemoryProperties
			
			debug("Building Rete")
			val watch = Stopwatch.createStarted
			val matcher = specification.getMatcher(incQueryEngine)
			watch.stop()
			val countMatches = matcher.countMatches
			val usedHeapAfter = logMemoryProperties
			
			val usedHeap = usedHeapAfter - usedHeapBefore
			results.put(specification.getFullyQualifiedName, usedHeap)
			info("Pattern " + specification.fullyQualifiedName + "( " + countMatches + " matches, used " + usedHeap +
					" kByte heap, took " + watch.elapsed(TimeUnit.MILLISECONDS) + " ms)")
			
			incQueryEngine.wipe
			logMemoryProperties
		}
		
		info("Finished query performance test")
		
		printResults()
	}
	
	def printResults() {
		
		val resultSB = new StringBuilder("\n\nRegression test results:\n")
		results.entrySet.forEach[entry |
			resultSB.append("  " + entry.key + "," + entry.value + "\n")
		]
		info(resultSB)
		
	}
	
	/**
	 * Calls garbage collector 5 times, sleeps 1 second and logs the used, total and free heap sizes in MByte.
	 * 
	 * @param logger
	 * @return The amount of used heap memory in kBytes
	 */
	def static logMemoryProperties() {
		(0..4).forEach[Runtime.getRuntime().gc()]
		
		try {
			Thread.sleep(1000)
		} catch (InterruptedException e) {
			trace("Sleep after GC interrupted")
		}
		
		val totalHeapKB = Runtime.getRuntime().totalMemory() / 1024;
		val freeHeapKB = Runtime.getRuntime().freeMemory() / 1024;
		val usedHeapKB = totalHeapKB - freeHeapKB;
		info("Used Heap size: " + usedHeapKB / 1024 + " MByte (Total: " + totalHeapKB / 1024 + " MByte, Free: " + freeHeapKB / 1024 + " MByte)")
		
		usedHeapKB
	}
}