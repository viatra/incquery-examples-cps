package org.eclipse.incquery.examples.cps.generator.impl.dtos

@Data
class HostClass {
	
	public String name;
	
	public MinMaxData<Integer> numberOfHostTypes;
	public MinMaxData<Integer> numberOfHostInstances;
	public MinMaxData<Integer> numberOfCommunicationLines;
	
}