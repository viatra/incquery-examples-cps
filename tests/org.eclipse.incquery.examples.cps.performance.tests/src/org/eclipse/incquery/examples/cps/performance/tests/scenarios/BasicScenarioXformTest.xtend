package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.base.Joiner
import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.dtos.CPSStats
import org.eclipse.incquery.examples.cps.generator.dtos.DeploymentStats
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.dtos.TraceabilityStats
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.benchmark.BenchmarkResult
import org.eclipse.incquery.examples.cps.performance.tests.queries.QueryRegressionTest
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.FixMethodOrder
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.MethodSorters
import org.junit.runners.Parameterized

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@RunWith(Parameterized)
abstract class BasicScenarioXformTest extends CPS2DepTest {
	
	protected Logger trainLogger = Logger.getLogger("cps.mondosam.log")
	protected Logger modelStatsLogger = Logger.getLogger("cps.stats.model")
	protected Logger memoryStatsLogger = Logger.getLogger("cps.stats.memory")
	protected Logger timeStatsLogger = Logger.getLogger("cps.stats.time")
	
	private boolean GENERATE_HEADER = false
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
//	@Ignore
	@Test(timeout=100000)
	def scale00000WarmUp(){
		val testId = "warmup"
		startTest(testId)
		
		executeScenarioXform(16)
	
		endTest(testId)
	}
	
	
//	@Ignore
	@Test(timeout=100000)
	def scale00001(){
		val testId = "scale1"
		startTest(testId)
		
		executeScenarioXform(1)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=100000)
	def scale00008(){
		val testId = "scale8"
		startTest(testId)
		
		executeScenarioXform(8)
	
		endTest(testId)
	}
		
//	@Ignore
	@Test(timeout=300000)
	def scale00016(){
		val testId = "scale16"
		startTest(testId)
		
		executeScenarioXform(16)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale00032(){
		val testId = "scale32"
		startTest(testId)
		
		executeScenarioXform(32)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale00064(){
		val testId = "scale64"
		startTest(testId)
		
		executeScenarioXform(64)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale00128(){
		val testId = "scale128"
		startTest(testId)
		
		executeScenarioXform(128)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale00256(){
		val testId = "scale256"
		startTest(testId)
		
		executeScenarioXform(256)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale00512(){
		val testId = "scale512"
		startTest(testId)
		
		executeScenarioXform(512)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale01024(){
		val testId = "scale1024"
		startTest(testId)
		
		executeScenarioXform(1024)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale01280(){
		val testId = "scale1280"
		startTest(testId)
		
		executeScenarioXform(1280)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale01536(){
		val testId = "scale1536"
		startTest(testId)
		
		executeScenarioXform(1536)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale02048(){
		val testId = "scale2048"
		startTest(testId)
		
		executeScenarioXform(2048)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale02304(){
		val testId = "scale2304"
		startTest(testId)
		
		executeScenarioXform(2304)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale02560(){
		val testId = "scale2560"
		startTest(testId)
		
		executeScenarioXform(2560)
	
		endTest(testId)
	}
	
	@Ignore
	@Test(timeout=600000)
	def scale03072(){
		val testId = "scale3072"
		startTest(testId)
		
		executeScenarioXform(3072)
	
		endTest(testId)
	}

	def IScenario getScenario(Random rand)
	
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
		val long incQueryMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(incQueryMemory)

		executeTransformation
		transformTime.stop;
		info("Xform1 time: " + transformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(transformTime.elapsed(TimeUnit.MILLISECONDS))
		
		val long firstTransformationMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(firstTransformationMemory)
		
		// Persist models if needed
		if(PropertiesUtil.persistResults){
			cps2dep.eResource.resourceSet.resources.forEach[save(null)]
		}
		
		// Modification
		var secondXformTime = Stopwatch.createStarted;
		firstModification(cps2dep, result)
		
		// Re-transformation
		executeTransformation
		secondXformTime.stop;
		info("Xform2 time: " + secondXformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(secondXformTime.elapsed(TimeUnit.MILLISECONDS))
		
		
		var thirdXformTime = Stopwatch.createStarted;
		secondModification(cps2dep, result)

		executeTransformation
		thirdXformTime.stop;
		info("Xform3 time: " + thirdXformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(thirdXformTime.elapsed(TimeUnit.MILLISECONDS))
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
		info("    Xform2 time: " + secondXformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("    Xform3 time: " + thirdXformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		info("****************************************************************************")
		
		// Log the benchmarkResult to separated logger
		trainLogger.info(result.toString)
		
		// Log the model stats to separated logger
		
		logModelStats(scenario.class.simpleName, size, cpsStats, depStats, traceStats)
		logMemoryStats(scenario.class.simpleName, size, generateMemory, incQueryMemory, firstTransformationMemory, lastTransformationMemory);
		logTimeStats(scenario.class.simpleName, size, generateTime.elapsed(TimeUnit.MILLISECONDS), transformInitTime.elapsed(TimeUnit.MILLISECONDS), transformTime.elapsed(TimeUnit.MILLISECONDS), secondXformTime.elapsed(TimeUnit.MILLISECONDS), thirdXformTime.elapsed(TimeUnit.MILLISECONDS))
	}

	val D = ModelStats.DELIMITER
	
	def void logTimeStats(String scenario, int scale, long generateTime, long incQInitTime, long transformTime, long secondXformTime, long thirdXformTime){
		// Header
		if(GENERATE_HEADER){
			timeStatsLogger.info(Joiner.on(D).join("Scenario", "Scale", "XForm",  "GenerateTime", "XformInitTime", "FirstXformTime", "SecondXformTime", "ThirdXformTime"))
		}

		// Body
		timeStatsLogger.info(Joiner.on(D).join(scenario, scale, xform.class.simpleName, generateTime, incQInitTime, transformTime, secondXformTime, thirdXformTime))
	}
	
	def void logMemoryStats(String scenario, int scale, long genMemory, long incQMemory, long firstTrafoMemory, long lastTrafoMemory){
		// Header
		if(GENERATE_HEADER){
			memoryStatsLogger.info(Joiner.on(D).join("Scenario", "Scale", "XForm", "AfterGenerate", "AfterXformInit", "AfterFirstXform", "AfterLastXform"))
		}
		// Body
		memoryStatsLogger.info(Joiner.on(D).join(scenario, scale, xform.class.simpleName, genMemory, incQMemory, firstTrafoMemory, lastTrafoMemory))
	}
	
	def void logModelStats(String scenario, int scale, CPSStats cpsStats, DeploymentStats depStats, TraceabilityStats traceStats){
		// Header
		if(GENERATE_HEADER){
			modelStatsLogger.info(Joiner.on(D).join("Scenario" , "Scale", "XForm", "CPSeObjects" , "CPSeReferences" + D 
				+ "DepeObjects" , "DepeReferences", "TraceeObjects", "TraceeReferences"+ D 
				+ "SUMeObjects" , "SUMeReferences"))
		}
		
		val sumEObjects = cpsStats.eObjects + depStats.eObjects + traceStats.eObjects
		val sumEReferences = cpsStats.eReferences + depStats.eReferences + traceStats.eReferences

		// Body
		modelStatsLogger.info(Joiner.on(D).join(scenario, scale, xform.class.simpleName, cpsStats.CSVEValues, depStats.CSVEValues, 
			traceStats.CSVEValues, sumEObjects, sumEReferences
		))
		
	}

	def void firstModification(CPSToDeployment cps2dep, BenchmarkResult result)
	
	
	def void secondModification(CPSToDeployment cps2dep, BenchmarkResult result)
	
	def String getModificationLabel()
}
