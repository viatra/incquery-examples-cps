package org.eclipse.incquery.examples.cps.generator.dtos

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem

@Data
class GeneratorInput {
	long seed;
	CyberPhysicalSystem cyberPhysicalSystem;
	GeneratorConstraints constraints;
	
	def copyOf(){
		
	}
}
