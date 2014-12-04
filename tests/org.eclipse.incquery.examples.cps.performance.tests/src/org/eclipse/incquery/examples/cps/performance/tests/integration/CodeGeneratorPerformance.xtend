package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.Joiner
import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableList
import java.util.Random
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.Generator
import org.eclipse.incquery.examples.cps.performance.tests.queries.QueryRegressionTest
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.ClientServerScenario
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.junit.Test

import static org.junit.Assert.assertTrue
import org.eclipse.incquery.examples.cps.deployment.common.DeploymentQueries
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.PublishSubscribeScenario

class CodeGeneratorPerformance extends CPSTestBase {
	
val seed = 11111
	val D = ModelStats.DELIMITER
	val GENRATE_HEADER = false
	
	protected extension CPSModelBuilderUtil modelBuilder = new CPSModelBuilderUtil
	protected extension Logger logger = Logger.getLogger("cps.performance.generator.Tests")
	protected Logger finalStatsLogger = Logger.getLogger("cps.stats.final")
	protected Logger hostStatsLogger = Logger.getLogger("cps.stats.host")
	protected Logger appStatsLogger = Logger.getLogger("cps.stats.app")
	protected Logger behStatsLogger = Logger.getLogger("cps.stats.beh")
	
	@Test
	def scenarios(){
		
		val Random rand = new Random(seed);
		
		//(LowSynch, SimpleScaling, ClientServer, PublishSubscribe)
		val scenarios = ImmutableList.builder
        	.add(new ClientServerScenario(rand))
//        	.add(new PublishSubscribeScenario(rand))
			.build
			
		val scales = ImmutableList.<Integer>builder
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
			info("###### " + scenario.class.simpleName + " ######")
			val scenarioName = scenario.class.simpleName
			
			for(scale : scales){
				
				var xform = new BatchIncQuery
				
				info("===== Scale: " + scale + " =====")
				// Create empty dep and trace models
				var cps2dep = prepareEmptyModel("testID")
				
				assertTrue(cps2dep != null)
				assertTrue(cps2dep.deployment != null)
				assertTrue(cps2dep.deployment.getHosts() != null)
				assertTrue(cps2dep.cps != null)
				

				// Generate CPS model
				var fragment = generateModel(scenario, scale, cps2dep.cps)
				
				// Transform
				xform.initializeTransformation(cps2dep)
				xform.executeTransformation
				xform.cleanupTransformation
				
				val engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.deployment);
				DeploymentQueries.instance.prepare(engine);
				val depStats = StatsUtil.generateStatsForDeployment(engine, cps2dep.deployment)
				depStats.log
				
				// Generate Code
				var codeGenerator = new Generator("org.eclipse.incquery.testcode", engine, false)
				
				var sumHostSize = 0 as long
				var appCount = 0
				var sumAppSize = 0 as long
				var behCount = 0
				var sumBehSize = 0 as long
				
				val fullTime = Stopwatch.createStarted
				for(DeploymentHost host : cps2dep.deployment.getHosts()){
					val hostTime = Stopwatch.createStarted
					val hostCodeLength = codeGenerator.generateHostCode(host).length;
					hostTime.stop
					sumHostSize += hostCodeLength
					
					val actAppCount = appCount
					val actSumAppSize = sumAppSize
					val actSumBehSize = sumBehSize
					for(DeploymentApplication app : host.getApplications()){
						val appTime = Stopwatch.createStarted
						val appCodeLength = codeGenerator.generateApplicationCode(app).length;
						appTime.stop
						appCount++
						sumAppSize += appCodeLength
						appStatsLogger.info(toCSV(scenarioName, scale, app.id, appCodeLength, appTime.elapsed(TimeUnit.MILLISECONDS)))
						
						val behTime = Stopwatch.createStarted
						val behCodeLength = codeGenerator.generateBehaviorCode(app.getBehavior()).length;
						behTime.stop
						behCount++
						sumBehSize += behCodeLength
						behStatsLogger.info(toCSV(scenarioName, scale, app.getBehavior().description, behCodeLength, behTime.elapsed(TimeUnit.MILLISECONDS)))
					} // Apps and Behaviors
					logHostStats(scenarioName, scale, hostCodeLength, hostTime, appCount, actAppCount, sumAppSize, actSumAppSize, sumBehSize, actSumBehSize)
				} // Hosts
				fullTime.stop
				val usedMemKB = QueryRegressionTest.logMemoryProperties				
				logFinalStats(scenarioName, scale, cps2dep, appCount, behCount, sumHostSize, sumAppSize, sumBehSize, fullTime, usedMemKB)
			
				// Cleanup
				if (engine != null) {
					engine.dispose
				}
				xform = null
				fragment = null
				cps2dep = null
				codeGenerator = null
				(0..4).forEach[Runtime.getRuntime().gc()]
				info("")
				info("")
				info("")
				info("")
			}
		}
	
		return;
	}
	
	def logHostStats(String scenario, Integer scale, int hostCodeLength, Stopwatch hostTime, int appCount, int actAppCount, long sumAppSize, long actSumAppSize, long sumBehSize, long actSumBehSize) {
		if(GENRATE_HEADER){
			hostStatsLogger.info(toCSV("Scenario", "Scale", "HostCodeLength", "GenerationTime", "AppCount"
				, "SumAppLength", "SumBehLength")
			)
		}
		hostStatsLogger.info(
			toCSV(scenario, scale, hostCodeLength, 
				hostTime.elapsed(TimeUnit.MILLISECONDS), appCount-actAppCount,
				sumAppSize - actSumAppSize, sumBehSize - actSumBehSize)
		)
	}
	
	def logFinalStats(String scenario, Integer scale, CPSToDeployment cps2dep, int appCount, int behCount, long sumHostSize, long sumAppSize, long sumBehSize, Stopwatch fullTime, long usedMemoryKB) {
		if(GENRATE_HEADER){
			finalStatsLogger.info(
				toCSV("Scenario", "Scale", "HostCount", "ApplicationCount", "BehaviorCount", "SumHostChar", 
						"SumAppChar", "SumBehChar", "TotalTime", "UsedMemoryKB")
			)
		}
		finalStatsLogger.info(toCSV(scenario, scale, cps2dep.deployment.getHosts().size, 
				appCount, behCount, sumHostSize, sumAppSize, sumBehSize, 
				fullTime.elapsed(TimeUnit.MILLISECONDS), usedMemoryKB)
		)
	}
	
	private def toCSV(Object... str){
		Joiner.on(D).join(str);
	}
	
	def generateModel(IScenario scenario, Integer scale, CyberPhysicalSystem model) {
		val const = scenario.getConstraintsFor(scale);
		
		val generTime = Stopwatch.createStarted
		val out =  CPSGeneratorBuilder.buildAndGenerateModel(seed, const, model);
		generTime.stop
		val AdvancedIncQueryEngine engine = AdvancedIncQueryEngine.from(out.engine);
		Validation.instance.prepare(engine);
		val stats = StatsUtil.generateStatsForCPS(engine, out.modelRoot)
		
		info(scenario.class.simpleName + D + scale + D + stats.eObjects + D + stats.eReferences + D + generTime.elapsed(TimeUnit.MILLISECONDS))
	
		engine.dispose
		out
	}
	
}