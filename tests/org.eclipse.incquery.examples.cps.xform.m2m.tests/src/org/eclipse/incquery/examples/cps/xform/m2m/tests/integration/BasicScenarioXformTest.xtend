package org.eclipse.incquery.examples.cps.xform.m2m.tests.integration

import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.BasicScenario
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.IScenario
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.xform.m2m.tests.CPS2DepTest
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

@RunWith(Parameterized)
class BasicScenarioXformTest extends CPS2DepTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	@Test
	def basicScenario1k(){
		val testId = "basicScenario1k"
		startTest(testId)
		
		executeScenarioXform(1000)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def basicScenario10k(){
		val testId = "basicScenario10k"
		startTest(testId)
		
		executeScenarioXform(10000)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def basicScenario100k(){
		val testId = "basicScenario100k"
		startTest(testId)
		
		executeScenarioXform(100000)
	
		endTest(testId)
	}
	
	@Ignore
	@Test
	def basicScenario1M(){
		val testId = "basicScenario1M"
		startTest(testId)
		
		executeScenarioXform(1000000)
	
		endTest(testId)
	}
	
	def executeScenarioXform(int size) {
		val seed = 11111
		val Random rand = new Random(seed);
		val BasicScenario bs = new BasicScenario(rand);
		bs.executeScenarioXformForConstraints(size, seed)
	}
	
	def executeScenarioXformForConstraints(IScenario scenario, int size, long seed) {	
		val constraints = scenario.getConstraintsFor(size);
		val cps2dep = prepareEmptyModel("testModel"+System.nanoTime);
		
		val CPSGeneratorInput input = new CPSGeneratorInput(seed, constraints, cps2dep.cps);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		var generateTime = Stopwatch.createStarted;
		var fragment = generator.process(plan, input);
		generateTime.stop;
		info("Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
			
		initializeTransformation(cps2dep)
		executeTransformation
		
		info("Adding new host instance")		
		val appType = cps2dep.cps.appTypes.head
		val hostInstance = cps2dep.cps.hostTypes.head.instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		executeTransformation
		
		info("Adding second new host instance")		
		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
		executeTransformation
	}
}