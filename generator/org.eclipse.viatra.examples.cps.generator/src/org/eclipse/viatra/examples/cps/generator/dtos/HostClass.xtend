package org.eclipse.viatra.examples.cps.generator.dtos

import java.util.Map
import org.eclipse.xtend.lib.annotations.Data


/*
 * If this DTO class was annotated with @Đata, then this would potentially cause a StackOverflowException 
 * when calculating hash code for the conatined communicationRation maps, for this map might contain 
 * a HostClass instance, whose communicationRatios map contains the container map's HostClass instance
 */ 
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