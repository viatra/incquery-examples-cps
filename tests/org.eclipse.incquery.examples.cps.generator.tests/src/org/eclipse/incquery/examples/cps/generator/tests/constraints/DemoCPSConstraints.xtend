package org.eclipse.incquery.examples.cps.generator.tests.constraints

import java.util.HashMap
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.impl.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints
import com.google.common.collect.ImmutableList

class DemoCPSConstraints implements ICPSConstraints {
	
	val hostClass1 = new HostClass(
						"FirstHostClass",
						new MinMaxData(1, 3), // HostTypes
						new MinMaxData(3, 10), // HostInstances
						new MinMaxData(1, 3) // CommLines
					)
	val hostClass2 = new HostClass(
					"SecondHostClass",
					new MinMaxData(1, 1), // HostTypes
					new MinMaxData(3, 3), // HostInstances
					new MinMaxData(1, 5) // CommLines		
				)
	
	
	override getNumberOfSignals() {
		new MinMaxData(1, 10);
	}
	
	override getApplicationClasses() {
		val firstAppClassAllocations = new HashMap();
		firstAppClassAllocations.put(hostClass1, 1);
		firstAppClassAllocations.put(hostClass2, 3);
		
		val secondAppClassAllocations = new HashMap();
		secondAppClassAllocations.put(hostClass1, 1);
		secondAppClassAllocations.put(hostClass2, 1);
		
		#[
			new AppClass(
				"FirstAppClass",
				new MinMaxData(5, 5), // AppTypes
				new MinMaxData(10, 10), // AppInstances
				new MinMaxData(3, 5), // States
				new MinMaxData(3, 10) // Transitions
				, new Percentage(80)
				, firstAppClassAllocations
			),
			
			new AppClass(
				"SecondAppClass",
				new MinMaxData(10, 10), // AppTypes       
				new MinMaxData(5, 10), // AppInstances  
				new MinMaxData(10, 15), // States         
				new MinMaxData(15, 15) // Transitions
				, new Percentage(100)
				, secondAppClassAllocations   		
			)
	];
	}
	
	override getHostClasses() {
		#[
			hostClass1,
			hostClass2
		];
	}
	
	override getSkippedPhases() {
		ImmutableList.of();
	}
	
	
}