package org.eclipse.incquery.examples.cps.generator.dtos

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem


class GeneratorFragment {
	public val GeneratorInput input;
	public CyberPhysicalSystem cyberPhysicalSystem;
	public int numberOfSignals;
	
	new(GeneratorInput input) {
		this.input = input;
		this.cyberPhysicalSystem = input.cyberPhysicalSystem;
		this.numberOfSignals = 0;
	}
	
}