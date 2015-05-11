package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.collect.ImmutableList
import com.google.common.collect.ImmutableSet
import com.google.common.collect.Sets
import eu.mondo.sam.core.BenchmarkEngine
import eu.mondo.sam.core.results.JsonSerializer
import eu.mondo.sam.core.scenarios.BenchmarkScenario
import java.util.Random
import org.apache.log4j.Logger
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.StatisticsBasedScenario
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchOptimized
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchSimple
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.PartialBatch
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.QueryResultTraceability
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ViatraTransformation
import org.junit.After
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameters
import org.eclipse.core.resources.IProject
import com.google.common.collect.ImmutableList
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchViatra
import org.junit.AfterClass
import org.junit.BeforeClass

/**
 * Tests the whole toolchain using each transformation one-by-one
 */
@RunWith(Parameterized)
class ToolchainPerformanceTest extends CPSTestBase {

//	protected Logger trainLogger = Logger.getLogger("cps.mondosam.log")
	protected Logger modelStatsLogger = Logger.getLogger("cps.stats.model")
	protected Logger memoryStatsLogger = Logger.getLogger("cps.stats.memory")
	protected Logger timeStatsLogger = Logger.getLogger("cps.stats.time")

	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	protected extension CPSTransformationWrapper xform
	protected extension CPSModelBuilderUtil modelBuilder
	
	static val RANDOM_SEED = 11111
	
	val int scale
	val IScenario scenario
	val GeneratorType generatorType
	val TransformationType wrapperType
	IProject project

	
	enum GeneratorType{
		DISTRIBUTED,
		JDT_BASED
	}
	

	enum TransformationType{
		BATCH_SIMPLE,
		BATCH_OPTIMIZED,
		BATCH_INCQUERY,
		BATCH_VIATRA,
		INCR_QUERY_RESULT_TRACEABILITY,
		INCR_EXPLICIT_TRACEABILITY,
		INCR_AGGREGATED,
		INCR_VIATRA
	}
	
	
	@Parameters(name = "{index}: {0}, model size: {1}, code generator: {2}")
    public static def xformSizeGenerator() {
		
        val xforms = ImmutableSet.builder
	        .add(TransformationType.BATCH_SIMPLE)
	        .add(TransformationType.BATCH_OPTIMIZED)
	        .add(TransformationType.BATCH_INCQUERY)
	        .add(TransformationType.BATCH_VIATRA)
	        .add(TransformationType.INCR_QUERY_RESULT_TRACEABILITY)
	        .add(TransformationType.INCR_EXPLICIT_TRACEABILITY)
	        .add(TransformationType.INCR_AGGREGATED)
	        .add(TransformationType.INCR_VIATRA)
			.build

		val codegens = ImmutableSet.builder
			.add(GeneratorType.DISTRIBUTED)
			.add(GeneratorType.JDT_BASED)
			.build
			
		val scenarios = ImmutableSet.builder
//			.add(new ClientServerScenario(new Random(RANDOM_SEED)))
			.add(new StatisticsBasedScenario(new Random(RANDOM_SEED)))
			.build 
			
        val scales = ImmutableList.builder
	        .add(1)
	        .add(1)
	        .add(1)
	        // warmup
	        .add(1)
	        .add(2)
//	        .add(4)
//			.add(8)
//			.add(16)
//        	.add(32)
//        	.add(64)
//        	.add(128)
//        	.add(256)
//        	.add(512)
//        	.add(1024)
			.build
		
		val data = Sets::cartesianProduct(xforms,codegens,scenarios)
       	data.map[ d |
	        scales.map[ scale |
        		#[d.get(0), scale, d.get(1), d.get(2)]
        	]
        ].flatten.map[it.toArray].toList
    }

	new(
		TransformationType wrapperType,
		int scale,
		GeneratorType generatorType,
		IScenario scenario
	) {
		this.scenario = scenario
		this.scale = scale 
		this.wrapperType = wrapperType
		this.generatorType = generatorType
		modelBuilder = new CPSModelBuilderUtil
		switch(wrapperType){
			case BATCH_SIMPLE: xform = new BatchSimple
			case BATCH_OPTIMIZED: xform = new BatchOptimized
			case BATCH_INCQUERY: xform = new BatchIncQuery
			case BATCH_VIATRA: xform = new BatchViatra
			case INCR_QUERY_RESULT_TRACEABILITY: xform = new QueryResultTraceability 
			case INCR_EXPLICIT_TRACEABILITY: xform = new ExplicitTraceability
			case INCR_AGGREGATED: xform = new PartialBatch
			case INCR_VIATRA: xform = new ViatraTransformation
		}
		
	}
	
	def startTest(){
    	info('''START TEST: Xform: «wrapperType», Gen: «generatorType», Scale: «scale», Scenario: «scenario.class.name»''')
    }
    
    def endTest(){
    	info('''END TEST: Xform: «wrapperType», Gen: «generatorType», Scale: «scale», Scenario: «scenario.class.name»''')
    }
	
	@BeforeClass
	static def callGCBefore(){
		callGC
	}
	
	@After
	def cleanup() {
		cleanupTransformation;
		
		if(project != null && project.exists){
			project.delete(true, true, new NullProgressMonitor)
		}
	}

	@AfterClass
	static def callGC(){
		(0..4).forEach[Runtime.getRuntime().gc()]
		
		try{
			Thread.sleep(1000)
		} catch (InterruptedException ex) {
			Logger.getLogger("cps.xform.CPS2DepTest").warn("Sleep after System GC interrupted")
		}
	}

	@Test(timeout=600000)
	def void completeToolchainIntegrationTest() {
		startTest

		// communication unit between the phases
		val CPSDataToken token = new CPSDataToken
		token.scenarioName = scenario.class.simpleName
		token.constraints = scenario.getConstraintsFor(scale)
		token.instancesDirPath = instancesDirPath
		token.generatorType = generatorType
		token.seed = RANDOM_SEED
		token.size = scale
		token.xform = xform
		
		val benchmarkScenario = scenario as BenchmarkScenario
		// these values are important for the results and reporting
		benchmarkScenario.size = scale
		benchmarkScenario.caseName = xform.class.simpleName
		benchmarkScenario.tool = "IncQuery"
		benchmarkScenario.runIndex = 1
		
		val engine = new BenchmarkEngine
		JsonSerializer::setResultPath("./results/json/")
		
		engine.runBenchmark(benchmarkScenario, token)

		endTest
	}

	

}
