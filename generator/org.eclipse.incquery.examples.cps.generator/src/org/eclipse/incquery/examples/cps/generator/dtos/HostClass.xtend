package org.eclipse.incquery.examples.cps.generator.dtos

import java.util.Map

class HostClass {
	
	public String name;
	
	public MinMaxData<Integer> numberOfHostTypes;
	public MinMaxData<Integer> numberOfHostInstances;
	public MinMaxData<Integer> numberOfCommunicationLines;
	public Map<HostClass, Integer> communicationRatios;
	
	new(String name,
		MinMaxData<Integer> numberOfHostTypes,
		MinMaxData<Integer> numberOfHostInstances,
		MinMaxData<Integer> numberOfCommunicationLines,
		Map<HostClass, Integer> communicationRatios
	){
		this.name = name;
		this.numberOfHostTypes = numberOfHostTypes
		this.numberOfHostInstances = numberOfHostInstances
		this.numberOfCommunicationLines = numberOfCommunicationLines
		this.communicationRatios = communicationRatios
	}
	
}