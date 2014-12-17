package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.CaseFormat
import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.core.resources.IFolder
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.ClientServerScenario
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorUtil

/**
 * Tests the whole toolchain using each transformation one-by-one
 */
@RunWith(Parameterized)
class CPSDemonstratorIntegrationTest extends CPS2DepTest {

	val seed = 11111
	val scale = 64
	val D = ModelStats.DELIMITER

	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}

	@Test
	def void completeToolchainIntegrationTest() {

		// Generate model
		val Random rand = new Random(seed)
		val scenario = new ClientServerScenario(rand)
		val const = scenario.getConstraintsFor(scale);

		val generationTime = Stopwatch.createStarted
		val cpsFragment = generate(const, seed)
		generationTime.stop
		val IncQueryEngine engine = IncQueryEngine.on(cpsFragment.modelRoot);
		Validation.instance.prepare(engine);
		val stats = StatsUtil.generateStatsForCPS(engine, cpsFragment.modelRoot)

		info(
			scenario.class.simpleName + D + scale + D + stats.eObjects + D + stats.eReferences + D +
				generationTime.elapsed(TimeUnit.MILLISECONDS))

		// TODO add infos and debugs
		val cps2dep = prepareEmptyModel("test_cpsID")

		cps2dep.cps = cpsFragment.modelRoot
		cps2dep.deployment = DeploymentFactory.eINSTANCE.createDeployment

		cps2dep.initializeTransformation

		// FIXME the incremental transformations for some reason don't work
		// Maybe the bug is associated with the engine used by the transformation
		executeTransformation

		val engine2 = IncQueryEngine.on(cps2dep)

		val projectName = "integration.test.generated.code"
		val codeGenerator = new CodeGenerator(projectName, engine2, true);
		val project = GeneratorHelper.createProject(projectName)
		val srcFolder = project.getFolder("src");
		val monitor = new NullProgressMonitor();
		if (!srcFolder.exists()) {
			srcFolder.create(true, true, monitor);
		}

		// Initial source generation
		GeneratorUtil.generateAll(cps2dep.deployment, codeGenerator, srcFolder)

		
		val changeMonitor = new DeploymentChangeMonitor

		changeMonitor.startMonitoring(cps2dep.deployment, engine2)

		info("Adding new host instance")
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)

		executeTransformation
		
		

		codeGenerator.writeChanges(changeMonitor, srcFolder)

	}

	def writeChanges(CodeGenerator generator, DeploymentChangeMonitor monitor, IFolder folder) {
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

	// TODO handle update and 
	// TODO handle delete simirarly
	}


	def purify(String string) {
		var String str = string.replace(' ', '_').toLowerCase.replaceAll("[^A-Za-z0-9]", "")
		return CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, str);
	}

	def generate(ICPSConstraints constraints, int i) {
		CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints);
	}

}
