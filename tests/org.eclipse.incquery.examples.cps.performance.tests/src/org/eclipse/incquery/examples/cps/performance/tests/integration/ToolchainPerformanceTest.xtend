package org.eclipse.incquery.examples.cps.performance.tests.integration

import com.google.common.base.CaseFormat
import com.google.common.collect.ImmutableSet
import com.google.common.collect.Sets
import java.util.List
import java.util.Random
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
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.performance.tests.scenarios.ClientServerScenario
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTestWithoutParameters
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchOptimized
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchSimple
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.PartialBatch
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.QueryResultTraceability
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorUtil
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameters
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator

/**
 * Tests the whole toolchain using each transformation one-by-one
 */
@RunWith(Parameterized)
class ToolchainPerformanceTest extends CPS2DepTestWithoutParameters {


	private enum GeneratorType{
		DISTRIBUTED,
		JDT_BASED
	}
	
	@Parameters(name = "{index}: {1}, model size: {2}, code generator: {3}")
    public static def xformSizeGenerator() {

		val transformation1 = #[new BatchSimple(),BatchSimple.simpleName]
		val transformation2 = #[new BatchOptimized(),BatchOptimized.simpleName]
		val transformation3 = #[new BatchIncQuery(),BatchIncQuery.simpleName]
		val transformation4 = #[new QueryResultTraceability(),QueryResultTraceability.simpleName]
		val transformation5 = #[new ExplicitTraceability(),ExplicitTraceability.simpleName]
		val transformation6 = #[new PartialBatch(),PartialBatch.simpleName]

        val xforms = ImmutableSet.builder
	        .add(transformation1)
			.add(transformation2)
        	.add(transformation3)
        	.add(transformation4)
			.add(transformation5)
			.add(transformation6)
			.build

		val sizes = ImmutableSet.builder
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

//		val codegens = ImmutableSet.builder
//			.add(new org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator())
//			.add(new org.eclipse.incquery.examples.cps.xform.m2t.jdt.CodeGenerator())

		val codegens = ImmutableSet.builder
			.add(ToolchainPerformanceTest.GeneratorType.DISTRIBUTED)
			.add(ToolchainPerformanceTest.GeneratorType.JDT_BASED)
			.build
		val data = Sets::cartesianProduct(xforms,sizes,codegens)
        data.map[
        	#[(it.get(0) as List<?>).get(0), (it.get(0) as List<?>).get(1), it.get(1),it.get(2)]
        ].map[it.toArray].toList
    }

	val seed = 11111
	val int scale
	val ToolchainPerformanceTest.GeneratorType generatorType
	val D = ModelStats.DELIMITER

	protected extension CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE

	new(CPSTransformationWrapper wrapper, String wrapperType, int scale, ToolchainPerformanceTest.GeneratorType generatorType) {
		super(wrapper, wrapperType)
		this.scale = scale 
		this.generatorType = generatorType
	}

	@Test
	def void completeToolchainIntegrationTest() {

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

		// Generate model
		val Random rand = new Random(seed)
		val scenario = new ClientServerScenario(rand)

		val const = scenario.getConstraintsFor(scale);

		val CPSGeneratorInput input = new CPSGeneratorInput(seed, const, cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		// Generating
		var fragment = generator.process(plan, input);

		val engine = AdvancedIncQueryEngine.from(fragment.engine);
		
		Validation.instance.prepare(engine);

		cps2dep.initializeTransformation

		executeTransformation

		val engine2 = IncQueryEngine.on(cps2dep)

		val projectName = "integration.test.generated.code"
		var ICPSGenerator codeGenerator = null
		if(generatorType.equals(GeneratorType.DISTRIBUTED)){
			codeGenerator = new org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator(projectName, engine2, true);
		} else if(generatorType.equals(GeneratorType.JDT_BASED)) {
			codeGenerator = new org.eclipse.incquery.examples.cps.xform.m2t.jdt.CodeGenerator(projectName, engine2);
		}
		val project = GeneratorHelper.createProject(projectName)
		val srcFolder = project.getFolder("src");
		val monitor = new NullProgressMonitor();
		if (!srcFolder.exists()) {
			srcFolder.create(true, true, monitor);
		}

		// Initial source generation
		GeneratorUtil.generateAll(cps2dep.deployment, codeGenerator, srcFolder)
	
		val changeMonitor = new DeploymentChangeMonitor(cps2dep.deployment, engine2)

		changeMonitor.startMonitoring

		info("Adding new host instance")
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)

		executeTransformation

		codeGenerator.writeChanges(changeMonitor, srcFolder)
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
		CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints);
	}

}
