package org.eclipse.incquery.examples.cps.generator.dtos

import com.google.common.collect.Lists
import java.util.List
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.planexecutor.generator.GeneratorInput
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IPhase
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IPlan

class GeneratorPlan implements IPlan<CPSFragment, GeneratorInput<CyberPhysicalSystem>> {
	
	List<IPhase<CPSFragment>> phases = Lists.newArrayList;
	
	override addPhase(IPhase<CPSFragment> phase) {
		phases.add(phase);
	}
	
	override getPhases() {
		return phases;
	}
	
	override getInitialFragment(GeneratorInput<CyberPhysicalSystem> input) {
		return new CPSFragment(input);
	}
	
}