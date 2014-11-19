package org.eclipse.incquery.examples.cps.generator.impl.dtos

import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import java.util.Map
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage

@Data
class AppClass {
	
	public String name;
	
	public MinMaxData<Integer> numberOfAppTypes;
	public MinMaxData<Integer> numberOfAppInstances;
	public MinMaxData<Integer> numberOfStates;
	public MinMaxData<Integer> numberOfTrannsitions;
	public Percentage percentOfAllocatedInstances;
	public Map<HostClass, Integer> allocationRatios;
	
}