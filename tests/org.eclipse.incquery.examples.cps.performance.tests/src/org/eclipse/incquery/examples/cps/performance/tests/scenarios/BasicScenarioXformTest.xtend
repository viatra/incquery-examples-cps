package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.base.Joiner
import java.util.Random
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

import org.eclipse.incquery.examples.cps.performance.tests.queries.QueryRegressionTest

import eu.mondo.sam.core.results.BenchmarkResult
import eu.mondo.sam.core.results.PhaseResult
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.BenchmarkEngine
import eu.mondo.sam.core.scenarios.BenchmarkScenario
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil

import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken

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
import eu.mondo.sam.core.results.JsonSerializer

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
	
//	@Ignore
	@Test(timeout=600000)
	def scale00064(){
		val testId = "scale64"
		startTest(testId)
		
		executeScenarioXform(64)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale00128(){
		val testId = "scale128"
		startTest(testId)
		
		executeScenarioXform(128)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale00256(){
		val testId = "scale256"
		startTest(testId)
		
		executeScenarioXform(256)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale00512(){
		val testId = "scale512"
		startTest(testId)
		
		executeScenarioXform(512)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale01024(){
		val testId = "scale1024"
		startTest(testId)
		
		executeScenarioXform(1024)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale01280(){
		val testId = "scale1280"
		startTest(testId)
		
		executeScenarioXform(1280)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale01536(){
		val testId = "scale1536"
		startTest(testId)
		
		executeScenarioXform(1536)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale02048(){
		val testId = "scale2048"
		startTest(testId)
		
		executeScenarioXform(2048)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale02304(){
		val testId = "scale2304"
		startTest(testId)
		
		executeScenarioXform(2304)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test(timeout=600000)
	def scale02560(){
		val testId = "scale2560"
		startTest(testId)
		
		executeScenarioXform(2560)
	
		endTest(testId)
	}
	
//	@Ignore
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
		
		val scenario = getScenario(rand)
		
		// communication unit between the phases
		val CPSDataToken token = new CPSDataToken
		token.scenarioName = scenario.class.simpleName
		token.constraints = scenario.getConstraintsFor(size)
		token.instancesDirPath = instancesDirPath
		token.seed = seed
		token.size = size
		token.xform = xform
		
		val benchmarkScenario = scenario as BenchmarkScenario
		// these values are important for the results and reporting
		benchmarkScenario.size = size
		benchmarkScenario.caseName = xform.class.simpleName
		benchmarkScenario.tool = "IncQuery"
		benchmarkScenario.runIndex = 1
		
		val engine = new BenchmarkEngine
		JsonSerializer::setResultPath("./results/json/")
		
		engine.runBenchmark(benchmarkScenario, token)
	}
	
	val D = ModelStats.DELIMITER
	
	def void logTimeStats(String scenario, int scale, String generateTime, String incQInitTime, String transformTime, String secondXformTime, String thirdXformTime){
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

//	def void firstModification(CPSToDeployment cps2dep, BenchmarkResult result)
	
	
//	def void secondModification(CPSToDeployment cps2dep, BenchmarkResult result)
	
	def String getModificationLabel()
}
