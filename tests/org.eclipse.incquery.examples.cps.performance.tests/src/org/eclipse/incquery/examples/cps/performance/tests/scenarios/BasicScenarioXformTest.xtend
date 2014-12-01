package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.benchmark.BenchmarkResult
import org.eclipse.incquery.examples.cps.performance.tests.queries.QueryRegressionTest
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSStats
import org.eclipse.incquery.examples.cps.generator.dtos.DeploymentStats
import org.eclipse.incquery.examples.cps.generator.dtos.TraceabilityStats
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats

@RunWith(Parameterized)
abstract class BasicScenarioXformTest extends CPS2DepTest {
	
	protected Logger trainLogger = Logger.getLogger("cps.trainbenchmark.log")
	protected Logger modelStatsLogger = Logger.getLogger("cps.modelstats.log")
	
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
	def scale8(){
		val testId = "scale8"
		startTest(testId)
		
		executeScenarioXform(8)
	
		endTest(testId)
	}
		
//	@Ignore
	@Test(timeout=300000)
	def scale16(){
		val testId = "scale16"
		startTest(testId)
		
		executeScenarioXform(16)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale32(){
		val testId = "scale32"
		startTest(testId)
		
		executeScenarioXform(32)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale64(){
		val testId = "scale64"
		startTest(testId)
		
		executeScenarioXform(64)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale128(){
		val testId = "scale128"
		startTest(testId)
		
		executeScenarioXform(128)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale256(){
		val testId = "scale256"
		startTest(testId)
		
		executeScenarioXform(256)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale512(){
		val testId = "scale512"
		startTest(testId)
		
		executeScenarioXform(512)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale1024(){
		val testId = "scale1024"
		startTest(testId)
		
		executeScenarioXform(1024)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale1280(){
		val testId = "scale1280"
		startTest(testId)
		
		executeScenarioXform(1280)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale1536(){
		val testId = "scale1536"
		startTest(testId)
		
		executeScenarioXform(1536)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale2048(){
		val testId = "scale2048"
		startTest(testId)
		
		executeScenarioXform(2048)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale2304(){
		val testId = "scale2304"
		startTest(testId)
		
		executeScenarioXform(2304)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale2560(){
		val testId = "scale2560"
		startTest(testId)
		
		executeScenarioXform(2560)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale3072(){
		val testId = "scale3072"
		startTest(testId)
		
		executeScenarioXform(3072)
	
		endTest(testId)
	}

	abstract def IScenario getScenario(Random rand)
	
	def executeScenarioXform(int size) {
		val seed = 11111
		val Random rand = new Random(seed);
		getScenario(rand).executeScenarioXformForConstraints(size, seed)
	}
	
	def executeScenarioXformForConstraints(IScenario scenario, int size, long seed) {
		
		// MONDO-SAM
		val BenchmarkResult result = new BenchmarkResult(xform.class.simpleName, modificationLabel, new Random(seed))
		result.scenario = scenario.class.simpleName
		result.benchmarkArtifact = "scale_" + size.toString
		
		// Constraints
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
		result.setReadTime(generateTime.elapsed(TimeUnit.MILLISECONDS))
		val long generateMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(generateMemory)
		
		
		val engine = AdvancedIncQueryEngine.from(fragment.engine);
		Validation.instance.prepare(engine);
		
		val cpsStats = StatsUtil.generateStatsForCPS(engine, fragment.modelRoot)
		result.artifactSize = cpsStats.eObjects
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
		result.addCheckTime(transformTime.elapsed(TimeUnit.MILLISECONDS))
		
		val long endMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(endMemory)
		
		// Persist models if needed
		if(PropertiesUtil.persistResults){
			cps2dep.eResource.resourceSet.resources.forEach[save(null)]
		}
		
		// Modification
		firstModification(cps2dep, result)
		
		// Re-transformation
		var secondXform = Stopwatch.createStarted;
		executeTransformation
		secondXform.stop;
		info("Xform2 time: " + secondXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(secondXform.elapsed(TimeUnit.MILLISECONDS))
		
		
		secondModification(cps2dep, result)

		var thirdXform = Stopwatch.createStarted;
		executeTransformation
		thirdXform.stop;
		info("Xform3 time: " + thirdXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(thirdXform.elapsed(TimeUnit.MILLISECONDS))
		val long lastTransformationMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(lastTransformationMemory)

		// STATS
		info("  ************************************************************************")
		info(" **                    S  T  A  T  I  S  T  I  C  S                      **")
		info("****************************************************************************")
		info(" BASIC INFORMATIONS:")
		info("    Scenario = " + scenario.class.simpleName)		
		info("    Size = " + size)		
		info("    Seed = " + seed)		
		info(" MODEL STATS:")
		cpsStats.log
		val depStats = StatsUtil.generateStatsForDeployment(engine, cps2dep.deployment)
		depStats.log
		val traceStats = StatsUtil.generateStatsForTraceability(engine, cps2dep)
		traceStats.log
		info(" EXECUTION TIMES: ")
		info("    Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform1 time: " + transformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("       Xform1 init time: " + transformInitTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform2 time: " + secondXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform3 time: " + thirdXform.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("****************************************************************************")
		
		// Log the benchmarkResult to separated logger
		trainLogger.info(result.toString)
		
		// Log the model stats to separated logger
		logModelStats(cpsStats, depStats, traceStats)
	}
	
	def void logModelStats(CPSStats cpsStats, DeploymentStats depStats, TraceabilityStats traceStats){
		// Header
		modelStatsLogger.info("ModelName" + ModelStats.DELIMITER + "EObjects" + ModelStats.DELIMITER + "EReferences")
		
		// Body
		cpsStats.logCSV(modelStatsLogger, "CPS")
		depStats.logCSV(modelStatsLogger, "Deployment")
		traceStats.logCSV(modelStatsLogger, "Traceability")
		val sumEObjects = cpsStats.eObjects + depStats.eObjects + traceStats.eObjects
		val sumEReferences = cpsStats.eReferences + depStats.eReferences + traceStats.eReferences
		modelStatsLogger.info("Sum" + ModelStats.DELIMITER + sumEObjects + ModelStats.DELIMITER + sumEReferences)
	}

	def void firstModification(CPSToDeployment cps2dep, BenchmarkResult result){
		info("Adding new host instance")
		var modifyTime1 = Stopwatch.createStarted;
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		var editTime1 = Stopwatch.createStarted;
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		editTime1.stop
		modifyTime1.stop
		result.addModificationTime(modifyTime1.elapsed(TimeUnit.MILLISECONDS))
		result.addEditTime(editTime1.elapsed(TimeUnit.MILLISECONDS))
	}
	
	
	def void secondModification(CPSToDeployment cps2dep, BenchmarkResult result){
		info("Adding second new host instance")	
		var modifyTime2 = Stopwatch.createStarted;	
		var editTime2 = Stopwatch.createStarted;
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
		editTime2.stop
		modifyTime2.stop
		result.addModificationTime(modifyTime2.elapsed(TimeUnit.MILLISECONDS))
		result.addEditTime(editTime2.elapsed(TimeUnit.MILLISECONDS))
	}
	
	abstract def String getModificationLabel()
}
