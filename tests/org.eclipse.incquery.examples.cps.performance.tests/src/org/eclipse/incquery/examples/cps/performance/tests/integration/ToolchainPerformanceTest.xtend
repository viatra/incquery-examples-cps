package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.CaseFormat
import com.google.common.base.Joiner
import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableSet
import com.google.common.collect.Sets
import java.util.Random
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.dtos.CPSStats
import org.eclipse.incquery.examples.cps.generator.dtos.DeploymentStats
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.dtos.TraceabilityStats
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.StatisticsBasedScenario
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.benchmark.BenchmarkResult
import org.eclipse.incquery.examples.cps.performance.tests.queries.QueryRegressionTest
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchOptimized
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchSimple
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.PartialBatch
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.QueryResultTraceability
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ViatraTransformation
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorUtil
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.emf.EMFScope
import org.junit.After
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameters
import org.eclipse.core.resources.IProject
import com.google.common.collect.ImmutableList

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
	protected extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	protected extension CPSTransformationWrapper xform
	protected extension CPSModelBuilderUtil modelBuilder
	
	static val RANDOM_SEED = 11111
	
	val D = ModelStats.DELIMITER
	private boolean GENERATE_HEADER = true
	val int scale
	val IScenario scenario
	val GeneratorType generatorType
	val TransformationType wrapperType
	IProject project

	private enum GeneratorType{
		DISTRIBUTED,
		JDT_BASED
	}

	private enum TransformationType{
		BATCH_SIMPLE,
		BATCH_OPTIMIZED,
		BATCH_INCQUERY,
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
	        .add(4)
			.add(8)
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
	
	@After
	def cleanup() {
		cleanupTransformation;
		
		if(project != null && project.exists){
			project.delete(true, true, new NullProgressMonitor)
		}
		
		(0..4).forEach[Runtime.getRuntime().gc()]
		
		try{
			Thread.sleep(1000)
		} catch (InterruptedException ex) {
			warn("Sleep after System GC interrupted")
		}
	}

	@Test(timeout=60000)
	def void completeToolchainIntegrationTest() {
		startTest
		
		val rs = new ResourceSetImpl()
		val cpsRes = rs.createResource(URI.createURI("cps.cyberphysicalsystem"))
		val depRes = rs.createResource(URI.createURI("deployment.deployment"))
		val trcRes = rs.createResource(URI.createURI("trace.traceability"))
		
		val cps = createCyberPhysicalSystem => [
			id = "cps"
		]
		cpsRes.contents += cps
		
		val dep = createDeployment
		depRes.contents += dep
		 
		val cps2dep = createCPSToDeployment => [
			it.cps = cps
			it.deployment = dep
		]
		trcRes.contents += cps2dep

		val BenchmarkResult result = new BenchmarkResult(xform.class.simpleName, scenario.class.simpleName, new Random(RANDOM_SEED))
		result.scenario = scenario.class.simpleName
		result.benchmarkArtifact = "scale_" + scale.toString
		

		// Generate model
		val const = scenario.getConstraintsFor(scale);

		val CPSGeneratorInput input = new CPSGeneratorInput(RANDOM_SEED, const, cps2dep.cps);
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
		
		Validation.instance.prepare(fragment.engine);
		val cpsStats = StatsUtil.generateStatsForCPS(fragment.engine, fragment.modelRoot)
		result.artifactSize = cpsStats.eObjects
		cpsStats.log
		fragment.engine.dispose

		// Transformation
		var m2mTransformTime = Stopwatch.createStarted;
		var m2mTransformInitTime = Stopwatch.createStarted;
		cps2dep.initializeTransformation
		m2mTransformInitTime.stop
		val long incQueryMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(incQueryMemory)


		executeTransformation
		m2mTransformTime.stop;
		info("M2M Xform1 time: " + m2mTransformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(m2mTransformTime.elapsed(TimeUnit.MILLISECONDS))

		val long firstTransformationMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(firstTransformationMemory)
		


		var m2tTransformTime = Stopwatch.createStarted;
		var m2tTransformInitTime = Stopwatch.createStarted;
		val engine2 = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep))

		val projectName = "integration.test.generated.code"
		var ICPSGenerator codeGenerator = null
		if(generatorType.equals(GeneratorType.DISTRIBUTED)){
			codeGenerator = new CodeGenerator(projectName, engine2, true);
		} else if(generatorType.equals(GeneratorType.JDT_BASED)) {
			codeGenerator = new org.eclipse.incquery.examples.cps.xform.m2t.jdt.CodeGenerator(projectName, engine2);
		}
		project = GeneratorHelper.createProject(projectName)
		val srcFolder = project.getFolder("src");
		val monitor = new NullProgressMonitor();
		if (!srcFolder.exists()) {
			srcFolder.create(true, true, monitor);
		}
		m2tTransformInitTime.stop

		// Initial source generation
		GeneratorUtil.generateAll(cps2dep.deployment, codeGenerator, srcFolder)
		m2tTransformTime.stop
		info("M2T Xform1 time: " + m2tTransformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(m2tTransformTime.elapsed(TimeUnit.MILLISECONDS))
		
	
		val changeMonitor = new DeploymentChangeMonitor(cps2dep.deployment, engine2)
		changeMonitor.startMonitoring

		// Modification
		var m2mSecondTransformTime = Stopwatch.createStarted;

		// TODO scenario should provide modification
		info("Adding new host instance")
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("AC_withStateMachine")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("HC_appContainer")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)

		executeTransformation
		m2mSecondTransformTime.stop
		info("M2M Xform2 time: " + m2mSecondTransformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(m2mSecondTransformTime.elapsed(TimeUnit.MILLISECONDS))


		var m2tSecondTransformTime = Stopwatch.createStarted;
		codeGenerator.writeChanges(changeMonitor, srcFolder)
		m2tSecondTransformTime.stop
		info("M2T Xform2 time: " + m2tSecondTransformTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		result.addCheckTime(m2tSecondTransformTime.elapsed(TimeUnit.MILLISECONDS))
		
		val long lastTransformationMemory = QueryRegressionTest.logMemoryProperties
		result.addMemoryBytes(lastTransformationMemory)
						
		val depStats = StatsUtil.generateStatsForDeployment(engine2, cps2dep.deployment)
		val traceStats = StatsUtil.generateStatsForTraceability(engine2, cps2dep)
		
		logModelStats(scenario.class.simpleName, scale, cpsStats, depStats, traceStats)
		logMemoryStats(scenario.class.simpleName, scale, generateMemory, incQueryMemory, firstTransformationMemory, lastTransformationMemory);
		logTimeStats(scenario.class.simpleName, scale, generateTime.elapsed(TimeUnit.MILLISECONDS), m2mTransformInitTime.elapsed(TimeUnit.MILLISECONDS), m2tTransformInitTime.elapsed(TimeUnit.MILLISECONDS), m2mTransformTime.elapsed(TimeUnit.MILLISECONDS),m2tTransformTime.elapsed(TimeUnit.MILLISECONDS),m2mSecondTransformTime.elapsed(TimeUnit.MILLISECONDS),m2tSecondTransformTime.elapsed(TimeUnit.MILLISECONDS) )
		
		engine2.dispose
		
		endTest
	}

	def writeChanges(ICPSGenerator generator, DeploymentChangeMonitor monitor, IFolder folder) {
		
		if (monitor.deltaSinceLastCheckpoint.oldNamesForDeletion != null) {
			for (depElem : monitor.deltaSinceLastCheckpoint?.oldNamesForDeletion?.keySet) {
				if (depElem instanceof DeploymentApplication) {
					// TODO Delete corresponding .java file
				} else if (depElem instanceof DeploymentHost) {
					// TODO Delete corresponding .java file
				}
			}
		}
		for (appeared : monitor.deltaSinceLastCheckpoint.appeared) {
			if (appeared instanceof DeploymentApplication) {
				val app = appeared as DeploymentApplication
				GeneratorHelper.createFile(folder, purify(app.id) + "Application.java", false,
					generator.generateApplicationCode(app), true);
			}
			if (appeared instanceof DeploymentHost) {
				val host = appeared as DeploymentHost
				GeneratorHelper.createFile(folder, "Host" + purify(host.ip) + ".java", false,
					generator.generateHostCode(host), true);
			}
			if (appeared instanceof DeploymentBehavior) {
				val behavior = appeared as DeploymentBehavior
				GeneratorHelper.createFile(folder, "Behavior" + purify(behavior.description) + ".java", false,
					generator.generateBehaviorCode(behavior), true);
			}
		}

	}


	def purify(String string) {
		var String str = string.replace(' ', '_').toLowerCase.replaceAll("[^A-Za-z0-9]", "")
		return CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, str);
	}

	def generate(ICPSConstraints constraints, int i) {
		CPSGeneratorBuilder.buildAndGenerateModel(RANDOM_SEED, constraints);
	}
	
	def void logTimeStats(String scenario, int scale, long generateTime, long incQInitTime, long codeGeneratorInitTime, long m2mTransformTime, long m2tTransformTime, long m2mSecondTransformTime, long m2tSecondTransformTime){
		// Header
		if(GENERATE_HEADER){
			timeStatsLogger.info(Joiner.on(D).join("Scenario", "Scale", "XForm",  "GenerateTime", "XformInitTime", "CodeGeneratorTime", "m2mXformTime", "m2tXformTime", "m2mSecondXformTime", "m2tSecondXformTime"))
		}

		// Body
		timeStatsLogger.info(Joiner.on(D).join(scenario, scale, xform.class.simpleName, generateTime, incQInitTime, codeGeneratorInitTime, m2mTransformTime, m2tTransformTime, m2mSecondTransformTime, m2tSecondTransformTime))
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

}
