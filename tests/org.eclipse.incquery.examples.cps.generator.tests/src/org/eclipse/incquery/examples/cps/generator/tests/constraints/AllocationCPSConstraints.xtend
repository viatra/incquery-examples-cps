package org.eclipse.incquery.examples.cps.generator.tests.constraints

import java.util.HashMap
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints

class AllocationCPSConstraints implements ICPSConstraints {
	
	public String name = "Allocation";
	
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
		val firstAppClassAllocations = new HashMap();
		firstAppClassAllocations.put(hostClass, 1);
		#[
			new AppClass(
				"FirstAppClass",
				new MinMaxData(2, 2), // AppTypes
				new MinMaxData(2, 2), // AppInstances
				new MinMaxData(2, 2), // States
				new MinMaxData(1, 1) // Transitions
				, new Percentage(100) // PercentageOfAllocatedInstances 
				, firstAppClassAllocations // allocationRatios
				, new Percentage(100) // probabilityOfActionGeneration
				, new Percentage(50) //probabilityOfSenAction
			)
		];
	}
	
	override getHostClasses() {
		#[
			hostClass
		];
	}
	
}