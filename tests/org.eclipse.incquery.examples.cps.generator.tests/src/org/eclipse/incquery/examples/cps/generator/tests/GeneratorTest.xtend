package org.eclipse.incquery.examples.cps.generator.tests

import org.eclipse.incquery.examples.cps.generator.tests.constraints.AllocationCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.DemoCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.HostClassesCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.LargeCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.OnlyHostTypesCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.SimpleCPSConstraints
import org.junit.Test

class GeneratorTest extends TestBase {
	
	@Test
	def void testSimple(){
		runGeneratorOn(new SimpleCPSConstraints(), 111111);
	}
	
	@Test
	def void testOnlyHostTypes(){
		runGeneratorOn(new OnlyHostTypesCPSConstraints(), 111111);
	}
	
	@Test
	def void testDemo(){
		runGeneratorOn(new DemoCPSConstraints(), 111111);
	}
	
	@Test
	def void testAllocation(){
		runGeneratorOn(new AllocationCPSConstraints(), 111111);
	}
	
	@Test
	def void testHostClasses(){
		runGeneratorOn(new HostClassesCPSConstraints(), 111111);
	}
	
	@Test
	def void testLargeModel(){
		runGeneratorOn(new LargeCPSConstraints(), 111111);
	}
	
}