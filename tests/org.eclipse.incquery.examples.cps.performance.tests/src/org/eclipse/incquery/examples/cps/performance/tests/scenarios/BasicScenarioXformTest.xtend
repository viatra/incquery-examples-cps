package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.eclipse.incquery.examples.cps.performance.tests.benchmark.BenchmarkResult
import org.eclipse.incquery.examples.cps.performance.tests.queries.QueryRegressionTest

@RunWith(Parameterized)
abstract class BasicScenarioXformTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
//	@Ignore
	@Test(timeout=10000)
	def scale1(){
		val testId = "scale1"
		startTest(testId)
		
		executeScenarioXform(1)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=100000)
	def scale10(){
		val testId = "scale10"
		startTest(testId)
		
		executeScenarioXform(10)
	
		endTest(testId)
	}
		
//	@Ignore
	@Test(timeout=300000)
	def scale20(){
		val testId = "scale20"
		startTest(testId)
		
		executeScenarioXform(20)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale50(){
		val testId = "scale50"
		startTest(testId)
		
		executeScenarioXform(50)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale100(){
		val testId = "scale100"
		startTest(testId)
		
		executeScenarioXform(100)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale200(){
		val testId = "scale200"
		startTest(testId)
		
		executeScenarioXform(200)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale500(){
		val testId = "scale500"
		startTest(testId)
		
		executeScenarioXform(500)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale750(){
		val testId = "scale750"
		startTest(testId)
		
		executeScenarioXform(750)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale1000(){
		val testId = "scale1000"
		startTest(testId)
		
		executeScenarioXform(1000)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale1200(){
		val testId = "scale1200"
		startTest(testId)
		
		executeScenarioXform(1200)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale1500(){
		val testId = "scale1500"
		startTest(testId)
		
		executeScenarioXform(1500)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale2000(){
		val testId = "scale2000"
		startTest(testId)
		
		executeScenarioXform(2000)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale2250(){
		val testId = "scale2250"
		startTest(testId)
		
		executeScenarioXform(2250)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale2500(){
		val testId = "scale2500"
		startTest(testId)
		
		executeScenarioXform(2500)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale3000(){
		val testId = "scale3000"
		startTest(testId)
		
		executeScenarioXform(3000)
	
		endTest(testId)
	}

	abstract def IScenario getScenario(Random rand)
	
	def executeScenarioXform(int size) {
		val seed = 11111
		val Random rand = new Random(seed);
		getScenario(rand).executeScenarioXformForConstraints(size, seed)
	}
	
	def executeScenarioXformForConstraints(IScenario scenario, int size, long seed) {
		
		val constraints = scenario.getConstraintsFor(size);
		val cps2dep = preparePersistedCPSModel(instancesDirPath + "/" + scenario.class.simpleName, xform.class.simpleName + size + "_"+System.nanoTime);
		
		val CPSGeneratorInput input = new CPSGeneratorInput(seed, constraints, cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		// Generating
		var generateTime = Stopwatch.createStarted;
		var fragment = generator.process(plan, input);
		generateTime.stop;
		info("Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");

		val engine = AdvancedIncQueryEngine.from(fragment.engine);
		Validation.instance.prepare(engine);
		
		val cpsStats = StatsUtil.generateStatsForCPS(engine, fragment.modelRoot)
		cpsStats.log
		
		engine.dispose


		// Transformation
		var transformTime = Stopwatch.createStarted;
		var transformInitTime = Stopwatch.createStarted;
		initializeTransformation(cps2dep)
		transformInitTime.stop
		executeTransformation
		transformTime.stop;
		info("Xform1 time: " + transformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		
		val long endMemory = QueryRegressionTest.logMemoryProperties
		
		
		if(PropertiesUtil.persistResults){
			cps2dep.eResource.resourceSet.resources.forEach[save(null)]
		}
		
		info("Adding new host instance")
		var modifTime1 = Stopwatch.createStarted;
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		modifTime1.stop

		var secondXform = Stopwatch.createStarted;
		executeTransformation
		secondXform.stop;
		info("Xform2 time: " + secondXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		info("Adding second new host instance")	
		var modifTime2 = Stopwatch.createStarted;	
		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
		modifTime2.stop

		var thirdXform = Stopwatch.createStarted;
		executeTransformation
		thirdXform.stop;
		info("Xform3 time: " + thirdXform.elapsed(TimeUnit.MILLISECONDS) + " ms");


		// STATS
		info("  ************************************************************************")
		info(" **                    S  T  A  T  I  S  T  I  C  S                      **")
		info("****************************************************************************")
		info(" BASIC INFORMATIONS:")
		info("    Scenario = " + scenario.class.simpleName)		
		info("    Size = " + size)		
		info("    Seed = " + seed)		
		info(" MODLE STATS:")
		StatsUtil.generateStatsForDeployment(engine, cps2dep.deployment).log
		StatsUtil.generateStatsForTraceability(engine, cps2dep).log
		cpsStats.log
		info(" EXECUTION TIMES: ")
		info("    Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform1 time: " + transformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("       Xform1 init time: " + transformInitTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform2 time: " + secondXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform3 time: " + thirdXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("****************************************************************************")

         //////////////////////
		// MONDO-SAM
		
		val BenchmarkResult result = new BenchmarkResult(xform.class.simpleName, "Addingnew", new Random(seed))
		result.setReadTime(generateTime.elapsed(TimeUnit.MILLISECONDS))
		
		result.addCheckTime(transformTime.elapsed(TimeUnit.MILLISECONDS))
		result.addCheckTime(secondXform.elapsed(TimeUnit.MILLISECONDS))
		result.addCheckTime(thirdXform.elapsed(TimeUnit.MILLISECONDS))
		
		result.addModificationTime(modifTime1.elapsed(TimeUnit.MILLISECONDS))
		result.addModificationTime(modifTime2.elapsed(TimeUnit.MILLISECONDS))
		
		result.addEditTime(modifTime1.elapsed(TimeUnit.MILLISECONDS))
		result.addEditTime(modifTime2.elapsed(TimeUnit.MILLISECONDS))
		
		result.addMemoryBytes(endMemory)
		
		info(result.toString)
	}
}
