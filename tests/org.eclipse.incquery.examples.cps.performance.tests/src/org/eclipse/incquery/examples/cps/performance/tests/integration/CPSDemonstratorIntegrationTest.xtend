package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.CaseFormat
import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.ClientServerScenario
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.junit.Test
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior

/**
 * Tests the whole toolchain using one specific transformation
 */
class CPSDemonstratorIntegrationTest extends CPS2DepTest{
	
	val seed = 11111
	int scale = 64
	val D = ModelStats.DELIMITER
	
	new() {
		super(new BatchIncQuery, "BatchIncQuery")
//		super(new QueryResultTraceability, "BatchIncQuery")
	}

	@Test
	def void completeToolchainIntegrationTest(){
		val Random rand = new Random(seed)
		
		val scenario = new ClientServerScenario(rand)
		
		val const = scenario.getConstraintsFor(scale);
				
		val generationTime = Stopwatch.createStarted
		val cpsFragment =  generate(const, seed)
		generationTime.stop
		val IncQueryEngine engine = IncQueryEngine.on(cpsFragment.modelRoot);
		Validation.instance.prepare(engine);
		val stats = StatsUtil.generateStatsForCPS(engine, cpsFragment.modelRoot)
				
		info(scenario.class.simpleName + D + scale + D + stats.eObjects + D + stats.eReferences + D + generationTime.elapsed(TimeUnit.MILLISECONDS))

		// TODO add infos and debugs
				
		val rs = new ResourceSetImpl
		val resource = rs.createResource(URI.createURI("DummyURI"));				
				
		val cps2dep = TraceabilityFactory.eINSTANCE.createCPSToDeployment
		resource.contents += cps2dep
		cps2dep.cps = cpsFragment.modelRoot
		cps2dep.deployment = DeploymentFactory.eINSTANCE.createDeployment		
		
		cps2dep.initializeTransformation
		executeTransformation
		
		val engine2 = IncQueryEngine.on(rs)

		val projectName = "integration.test.generated.code"
		val codeGenerator = new CodeGenerator(projectName,engine2,true);
		val project = GeneratorHelper.createProject(projectName)
		val srcFolder = project.getFolder("src");
		val monitor = new NullProgressMonitor();
		if(!srcFolder.exists()){
			srcFolder.create(true, true, monitor);
		}
		// TODO this method is not implemented yet 
		// codeGenerator.generateDeploymentCode(cps2dep.deployment)
		// The implementation of the following method could be moved to (generateDeploymentCode)
		codeGenerator.generateCode(cps2dep.deployment,srcFolder) 
		
		val changeMonitor = new DeploymentChangeMonitor
		
		changeMonitor.startMonitoring(cps2dep.deployment,engine2)

		info("Adding new host instance")
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		
		executeTransformation
		
		codeGenerator.writeChanges(changeMonitor,srcFolder)		

	}
	
	def writeChanges(CodeGenerator generator, DeploymentChangeMonitor monitor, IFolder folder) {
		for(appeared : monitor.deltaSinceLastCheckpoint.appeared){
			if(appeared instanceof DeploymentApplication){
				val app = appeared as DeploymentApplication
				GeneratorHelper.createFile(folder, purify(app.id) + "Application.java", false, generator.generateApplicationCode(app), true);
			}
			if(appeared instanceof DeploymentHost){
				val host = appeared as DeploymentHost
				GeneratorHelper.createFile(folder, "Host" + purify(host.ip) + ".java", false, generator.generateHostCode(host), true);
			}
			if(appeared instanceof DeploymentBehavior){
				val behavior = appeared as DeploymentBehavior
				GeneratorHelper.createFile(folder, "Behavior" + purify(behavior.description) + ".java", false, generator.generateBehaviorCode(behavior), true);
			}
		}
		// TODO handle update and 
		// TODO handle delete simirarly
	}
	
	def generateCode(CodeGenerator generator, Deployment deployment, IFolder folder) {
		for(host : deployment.hosts){
			GeneratorHelper.createFile(folder, "Host" + purify(host.ip) + ".java", false, generator.generateHostCode(host), true);
			for(app : host.applications){
				GeneratorHelper.createFile(folder, purify(app.id) + "Application.java", false, generator.generateApplicationCode(app), true);
				
				val behavior = app.behavior
				GeneratorHelper.createFile(folder, "Behavior" + purify(behavior.description) + ".java", false, generator.generateBehaviorCode(behavior), true);
			}
		}
	}
	
	def purify(String string) {
		var String str = string.replace(' ', '_').toLowerCase.replaceAll("[^A-Za-z0-9]", "")
		return CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, str);
	}
	
	def generate(ICPSConstraints constraints, int i) {
		CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints);
	}
	
}