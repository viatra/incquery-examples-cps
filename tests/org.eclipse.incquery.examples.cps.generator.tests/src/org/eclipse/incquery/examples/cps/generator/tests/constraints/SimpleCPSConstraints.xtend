package org.eclipse.incquery.examples.cps.generator.tests.constraints

import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints

class SimpleCPSConstraints implements ICPSConstraints {
	
	public String name = "Simple";
	
	override getNumberOfSignals() {
		new MinMaxData(1, 10);
	}
	
	override getApplicationClasses() {
		#[
			new AppClass(
				"FirstAppClass",
				new MinMaxData(1, 1), // AppTypes
				new MinMaxData(1, 1), // AppInstances
				new MinMaxData(1, 1), // States
				new MinMaxData(1, 1) // Transitions
			)
	];
	}
	
	override getHostClasses() {
		#[
			new HostClass(
				"FirstHostClass",
				new MinMaxData(1, 1), // HostTypes
				new MinMaxData(1, 1), // HostInstances
				new MinMaxData(1, 1) // CommLines
			)
		];
	}
	
	
}