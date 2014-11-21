package org.eclipse.incquery.examples.cps.generator.dtos

import java.util.Map

@Data
class AppClass {
	
	public String name;
	
	public MinMaxData<Integer> numberOfAppTypes;
	public MinMaxData<Integer> numberOfAppInstances;
	public MinMaxData<Integer> numberOfStates;
	public MinMaxData<Integer> numberOfTrannsitions;
	public Percentage percentOfAllocatedInstances;
	public Map<HostClass, Integer> allocationRatios;
	public Percentage probabilityOfActionGeneration;
	public Percentage probabilityOfSendAction;
	
}