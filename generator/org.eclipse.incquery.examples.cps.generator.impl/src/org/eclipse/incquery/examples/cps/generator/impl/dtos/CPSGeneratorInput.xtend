package org.eclipse.incquery.examples.cps.generator.impl.dtos

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorConstraints

class CPSGeneratorInput extends GeneratorInput<CyberPhysicalSystem> {
	
	new(long seed, IGeneratorConstraints constraints, CyberPhysicalSystem modelRoot) {
		super(seed, constraints, modelRoot)
	}
	
}