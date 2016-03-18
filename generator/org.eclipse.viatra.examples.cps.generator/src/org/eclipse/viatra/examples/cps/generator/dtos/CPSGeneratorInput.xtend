package org.eclipse.viatra.examples.cps.generator.dtos

import org.eclipse.viatra.examples.cps.generator.dtos.bases.GeneratorInput
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.viatra.examples.cps.generator.interfaces.IConstraints

class CPSGeneratorInput extends GeneratorInput<CyberPhysicalSystem> {
	
	new(long seed, IConstraints constraints, CyberPhysicalSystem modelRoot) {
		super(seed, constraints, modelRoot)
	}
	
	override getInitialFragment() {
		return new CPSFragment(this);
	}
	
}