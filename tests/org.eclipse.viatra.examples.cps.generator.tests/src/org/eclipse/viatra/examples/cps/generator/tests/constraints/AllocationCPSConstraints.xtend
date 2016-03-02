package org.eclipse.viatra.examples.cps.generator.tests.constraints

import java.util.HashMap
import org.eclipse.viatra.examples.cps.generator.dtos.AppClass
import org.eclipse.viatra.examples.cps.generator.dtos.HostClass
import org.eclipse.viatra.examples.cps.generator.dtos.MinMaxData
import org.eclipse.viatra.examples.cps.generator.dtos.Percentage
import org.eclipse.viatra.examples.cps.generator.interfaces.ICPSConstraints

class AllocationCPSConstraints implements ICPSConstraints {
	
	
	public String name = "Allocation"
	val hostClass = new HostClass(
						"FirstHostClass",
						new MinMaxData(1, 1), // HostTypes
						new MinMaxData(2, 2), // HostInstances
						new MinMaxData(1, 1) // CommLines
						,new HashMap // Host Comm Ratio
					)
					
	val hostClass2 = new HostClass(
						"SecondHostClass",
						new MinMaxData(1, 1), // HostTypes
						new MinMaxData(2, 2), // HostInstances
						new MinMaxData(1, 1) // CommLines
						,new HashMap // Host Comm Ratio
					)
	
	override getNumberOfSignals() {
		new MinMaxData(1, 10);
	}
	
	override getApplicationClasses() {
		val firstAppClassAllocations = new HashMap();
		firstAppClassAllocations.put(hostClass, 1);
		firstAppClassAllocations.put(hostClass2, 1);
		#[
			new AppClass(
				"FirstAppClass",
				new MinMaxData(1, 1), // AppTypes
				new MinMaxData(6, 6), // AppInstances
				new MinMaxData(2, 2), // States
				new MinMaxData(1, 1) // Transitions
				, new Percentage(100)
				, firstAppClassAllocations
				, new Percentage(100)
				, new Percentage(50)
			)
		];
	}
	
	override getHostClasses() {
		hostClass.communicationRatios.put(hostClass, 1);
		hostClass.communicationRatios.put(hostClass2, 1);
		
		hostClass2.communicationRatios.put(hostClass2, 1);
		#[
			hostClass,
			hostClass2
		];
	}

	override getName() {
		return this.class.simpleName;
	}
	
}