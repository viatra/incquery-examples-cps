package org.eclipse.incquery.examples.cps.generator.tests

import java.util.Random
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.BasicScenario
import org.junit.Test

class ScenarioTest extends TestBase {
	
	@Test
	def basicScenario(){
		val seed = 11111
		val Random rand = new Random(seed);
		val BasicScenario bs = new BasicScenario(rand);
		val const = bs.getConstraintsFor(1000);
		
		runGeneratorOn(const, seed)
	
		return;
	}
	
}