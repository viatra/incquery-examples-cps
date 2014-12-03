package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableList
import java.util.Random
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.Generator
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.ClientServerScenario
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.PublishSubscribeScenario
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.junit.Test

import static org.junit.Assert.assertTrue
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem

class CodeGeneratorPerformance extends CPSTestBase {
	
val seed = 11111
	val D = ModelStats.DELIMITER
	
	protected extension CPSModelBuilderUtil modelBuilder = new CPSModelBuilderUtil
	protected extension Logger logger = Logger.getLogger("cps.performance.generator.Tests")
	
	@Test
	def scenarios(){
		
		val Random rand = new Random(seed);
		
		//(LowSynch, SimpleScaling, ClientServer, PublishSubscribe)
		val scenarios = ImmutableList.builder
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
			
		val xform = new BatchIncQuery
		
		
		for(scenario : scenarios){
			for(scale : scales){
				// Create empty dep and trace models
				val cps2dep = prepareEmptyModel("testID")
				
				assertTrue(cps2dep != null)
				assertTrue(cps2dep.deployment != null)
				assertTrue(cps2dep.deployment.getHosts() != null)
				assertTrue(cps2dep.cps != null)
				

				// Generate CPS model
				generateModel(scenario, scale, cps2dep.cps)
				
				// Transform
				xform.initializeTransformation(cps2dep)
				xform.executeTransformation
				
				// Generate Code
				val codeGenerator = new Generator("org.eclipse.incquery.testcode")
				
				val fullTime = Stopwatch.createStarted
				for(DeploymentHost host : cps2dep.deployment.getHosts()){
					val hostTime = Stopwatch.createStarted
					val hostCode = codeGenerator.generateHostCode(host);
					hostTime.stop
					info("  Host Generation [" + hostCode.length + " chars] Time: " + hostTime.elapsed(TimeUnit.MILLISECONDS) + " ms" )
					
					for(DeploymentApplication app : host.getApplications()){
						val appTime = Stopwatch.createStarted
						val appCode = codeGenerator.generateApplicationCode(app);
						appTime.stop
						info("  Host Generation [" + appCode.length + " chars] Time: " + appTime.elapsed(TimeUnit.MILLISECONDS) + " ms" )
						
						val behTime = Stopwatch.createStarted
						val behCode = codeGenerator.generateBehaviorCode(app.getBehavior());
						behTime.stop
						info("  Host Generation [" + behCode.length + " chars] Time: " + behTime.elapsed(TimeUnit.MILLISECONDS) + " ms" )
					}
				}
				fullTime.stop
				info("Full Generation Time: " + fullTime.elapsed(TimeUnit.MILLISECONDS) + " ms")
				
			}
		}
	
		return;
	}
	
	def generateModel(IScenario scenario, Integer scale, CyberPhysicalSystem model) {
		val const = scenario.getConstraintsFor(scale);
		
		val generTime = Stopwatch.createStarted
		val out =  CPSGeneratorBuilder.buildAndGenerateModel(seed, const, model);
		generTime.stop
		val IncQueryEngine engine = IncQueryEngine.on(out.modelRoot);
		Validation.instance.prepare(engine);
		val stats = StatsUtil.generateStatsForCPS(engine, out.modelRoot)
		
		info(scenario.class.simpleName + D + scale + D + stats.eObjects + D + stats.eReferences + D + generTime.elapsed(TimeUnit.MILLISECONDS))
	
		out.modelRoot
	}
	
}