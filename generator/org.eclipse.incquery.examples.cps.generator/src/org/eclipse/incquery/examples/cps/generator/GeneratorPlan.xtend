package org.eclipse.incquery.examples.cps.generator

import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorPlan
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import com.google.common.collect.Lists
import java.util.List
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput

class GeneratorPlan implements IGeneratorPlan<CyberPhysicalSystem, CPSFragment> {
	
	List<IGenratorPhase<CyberPhysicalSystem, CPSFragment>> phases = Lists.newArrayList;
	
	override addPhase(IGenratorPhase<CyberPhysicalSystem, CPSFragment> phase) {
		phases.add(phase);
	}
	
	override getPhases() {
		return phases;
	}
	
	override getInitialFragment(GeneratorInput<CyberPhysicalSystem> input) {
		return new CPSFragment(input);
	}
	
}