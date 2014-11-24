package org.eclipse.incquery.examples.cps.generator.tests

import java.util.Random
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.BasicScenario
import org.junit.Test
import org.junit.Ignore

class ScenarioTest extends TestBase {

	/**
	 * 1K ==> 866, 333ms
	 * 2K ==> 2757, 658ms
	 * 7K ==> 10894, 1770ms
	 * 40K ==> 101758, 4241ms
	 * 190K ==> 1,083M EObjects, 97mp 
	 */
	@Ignore
	@Test
	def basicScenario(){
		val seed = 11111
		val Random rand = new Random(seed);
		val BasicScenario bs = new BasicScenario(rand);
		val const = bs.getConstraintsFor(40000);		
		runGeneratorOn(const, seed)
	
		return;
	}
	
}