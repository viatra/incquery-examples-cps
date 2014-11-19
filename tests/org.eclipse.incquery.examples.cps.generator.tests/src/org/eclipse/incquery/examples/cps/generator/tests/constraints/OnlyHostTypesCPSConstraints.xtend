package org.eclipse.incquery.examples.cps.generator.tests.constraints

import com.google.common.collect.ImmutableList
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints

class OnlyHostTypesCPSConstraints implements ICPSConstraints {
	
	public String name = "OnlyHostTypes";
	
	override getNumberOfSignals() {
		new MinMaxData(1, 1);
	}
	
	override getApplicationClasses() {
		ImmutableList.of();
	}
	
	override getHostClasses() {
		#[
			new HostClass(
						"FirstHostClass",
						new MinMaxData(2, 2), // HostTypes
						new MinMaxData(0, 0), // HostInstances
						new MinMaxData(0, 0) // CommLines
					)
		];
	}	
}