package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import javax.print.attribute.standard.PrinterURI
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil

@RunWith(Parameterized)
abstract class BasicScenarioXformTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
//	@Ignore
	@Test
	def scale1(){
		val testId = "scale1"
		startTest(testId)
		
		executeScenarioXform(1)
	
		endTest(testId)
	}
	
//	@Ignore
	@Test
	def scale10(){
		val testId = "scale10"
		startTest(testId)
		
		executeScenarioXform(10)
	
		endTest(testId)
	}
		
//	@Ignore
	@Test
	def scale20(){
		val testId = "scale20"
		startTest(testId)
		
		executeScenarioXform(20)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def scale50(){
		val testId = "scale50"
		startTest(testId)
		
		executeScenarioXform(50)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def scale100(){
		val testId = "scale100"
		startTest(testId)
		
		executeScenarioXform(100)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def scale200(){
		val testId = "scale200"
		startTest(testId)
		
		executeScenarioXform(200)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def scale500(){
		val testId = "scale500"
		startTest(testId)
		
		executeScenarioXform(500)
	
		endTest(testId)
	}

	abstract def IScenario getScenario(Random rand)
	
	def executeScenarioXform(int size) {
		val seed = 11111
		val Random rand = new Random(seed);
		getScenario(rand).executeScenarioXformForConstraints(size, seed)
	}
	
	def executeScenarioXformForConstraints(IScenario scenario, int size, long seed) {	
		val constraints = scenario.getConstraintsFor(size);
		val cps2dep = preparePersistedCPSModel(instancesDirPath + "/" + scenario.class.simpleName,"batchSimple_" + size + "_"+System.nanoTime);
		
		val CPSGeneratorInput input = new CPSGeneratorInput(seed, constraints, cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		var generateTime = Stopwatch.createStarted;
		var fragment = generator.process(plan, input);
		generateTime.stop;
		info("Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");

		val engine = AdvancedIncQueryEngine.from(fragment.engine);
		Validation.instance.prepare(engine);
		
		StatsUtil.logStats(StatsUtil.generateStats(engine, fragment.modelRoot), logger);
		
		engine.dispose
		
		generateTime.reset.start
		initializeTransformation(cps2dep)
		executeTransformation
		generateTime.stop;
		info("Xform1 time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		if(PropertiesUtil.persistResults){
			cps2dep.eResource.resourceSet.resources.forEach[save(null)]
		}
		
//		info("Adding new host instance")		
//		val appType = cps2dep.cps.appTypes.head
//		val hostInstance = cps2dep.cps.hostTypes.head.instances.head
//		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
//
//		generateTime.reset.start
//		executeTransformation
//		generateTime.stop;
//		info("Xform2 time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
//		
//		info("Adding second new host instance")		
//		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
//
//		generateTime.reset.start
//		executeTransformation
//		generateTime.stop;
//		info("Xform3 time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
	}
}