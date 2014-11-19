package org.eclipse.incquery.examples.cps.generator.tests.constraints

import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints

class HostClassesCPSConstraints implements ICPSConstraints {
	
	public String name = "HostClasses";
	
	val hostClass = new HostClass(
						"FirstHostClass",
						new MinMaxData(2, 2), // HostTypes
						new MinMaxData(2, 2), // HostInstances
						new MinMaxData(1, 1) // CommLines
					)
	
	
	override getNumberOfSignals() {
		new MinMaxData(1, 10);
	}
	
	override getApplicationClasses() {
		#[
		];
	}
	
	override getHostClasses() {
		#[
			hostClass
		];
	}	
}