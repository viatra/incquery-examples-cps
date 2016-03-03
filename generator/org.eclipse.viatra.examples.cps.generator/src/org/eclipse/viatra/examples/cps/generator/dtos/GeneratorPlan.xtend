package org.eclipse.viatra.examples.cps.generator.dtos

import com.google.common.collect.Lists
import java.util.List
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.generator.dtos.bases.GeneratorInput
import org.eclipse.viatra.examples.cps.planexecutor.api.IPhase
import org.eclipse.viatra.examples.cps.planexecutor.api.IPlan

class GeneratorPlan implements IPlan<CPSFragment> {
	
	List<IPhase<CPSFragment>> phases = Lists.newArrayList;
	
	override addPhase(IPhase<CPSFragment> phase) {
		phases.add(phase);
	}
	
	override getPhases() {
		return phases;
	}
	
}