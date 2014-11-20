package org.eclipse.incquery.examples.cps.generator.tests.constraints

import com.google.common.collect.ImmutableList
import java.util.HashMap
import org.eclipse.incquery.examples.cps.generator.impl.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints

class LargeCPSConstraints implements ICPSConstraints {
	
	val hostClass1 = new HostClass(
						"HostClass_1",
						new MinMaxData(10, 50), // HostTypes
						new MinMaxData(40, 70), // HostInstances
						new MinMaxData(1, 30) // CommLines
					)
	val hostClass2 = new HostClass(
					"HostClass_2",
					new MinMaxData(30, 35), // HostTypes
					new MinMaxData(40, 50), // HostInstances
					new MinMaxData(1, 30) // CommLines		
				)
	val hostClass3 = new HostClass(
					"HostClass_3",
					new MinMaxData(10, 30), // HostTypes
					new MinMaxData(30, 30), // HostInstances
					new MinMaxData(1, 5) // CommLines		
				)
	
	
	override getNumberOfSignals() {
		new MinMaxData(1, 100);
	}
	
	override getApplicationClasses() {
		val firstAppClassAllocations = new HashMap();
		firstAppClassAllocations.put(hostClass1, 1);
		firstAppClassAllocations.put(hostClass2, 3);
		firstAppClassAllocations.put(hostClass3, 3);
		
		val secondAppClassAllocations = new HashMap();
		secondAppClassAllocations.put(hostClass1, 1);
		secondAppClassAllocations.put(hostClass2, 5);
		
		#[
			new AppClass(
				"FirstAppClass",
				new MinMaxData(10, 30), // AppTypes
				new MinMaxData(30, 70), // AppInstances
				new MinMaxData(20, 50), // States
				new MinMaxData(10, 20) // Transitions
				, new Percentage(80)
				, firstAppClassAllocations
			),
			
			new AppClass(
				"SecondAppClass",
				new MinMaxData(30, 50), // AppTypes       
				new MinMaxData(25, 40), // AppInstances  
				new MinMaxData(10, 55), // States         
				new MinMaxData(15, 35) // Transitions
				, new Percentage(100)
				, secondAppClassAllocations   		
			)
	];
	}
	
	override getHostClasses() {
		#[
			hostClass1,
			hostClass2,
			hostClass3
		];
	}
	
}