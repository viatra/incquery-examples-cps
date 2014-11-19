package org.eclipse.incquery.examples.cps.generator.impl

import com.google.common.collect.Lists
import java.util.List
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.operations.HostInstanceCommunicatesWithOperation
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class CPSPhaseHostCommunication implements IGenratorPhase<CyberPhysicalSystem, CPSFragment>{
	
	private extension RandomUtils randUtil = new RandomUtils;
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		// Generate communications
		if(fragment.hostInstances.values.size > 1){ // Skip if only one host instance exists
			for(hostClass : fragment.hostInstances.keys){ // HostClasses store the configuration
				for(hostInstance : fragment.hostInstances.get(hostClass)){ // Every HostInstance 
					// Initialize list of forbidden targets
					var List<HostInstance> forbiddenTargetInstances = Lists.newArrayList;
					// Add itself to the forbidden targets
					forbiddenTargetInstances.add(hostInstance); 
					// Calculate the number of new communication links
					val numberOfCommLinks = hostClass.numberOfCommunicationLines.randInt(fragment.random); 
					// Create communication links
					for(i : 0 ..< numberOfCommLinks){
						val targetHostInstance = fragment.hostInstances.values.randElementExcept(forbiddenTargetInstances, fragment.random);
						if(targetHostInstance != null){
							forbiddenTargetInstances.add(targetHostInstance);
							operations.add(new HostInstanceCommunicatesWithOperation(hostInstance, targetHostInstance));
						}
					}
				}
			}
		}
		
		return operations;
	}
	
}