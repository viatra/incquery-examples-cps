package org.eclipse.incquery.examples.cps.generator.impl.phases

import com.google.common.collect.Lists
import java.util.List
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.operations.HostInstanceCommunicatesWithOperation
import org.eclipse.incquery.examples.cps.generator.impl.utils.RandomUtils
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase

class CPSPhaseHostCommunication implements IGenratorPhase<CyberPhysicalSystem, CPSFragment>{
	
	private extension RandomUtils randUtil = new RandomUtils;
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
	
		// TODO optimize!
		var hostInstances = Lists.newArrayList;
		for(hostClass : fragment.hostTypes.keySet){
			for(hostType : fragment.hostTypes.get(hostClass)){
				hostInstances.addAll(hostType.instances);
			}		
		}


		// Generate communications
		for(hostClass : fragment.hostTypes.keySet){ // HostClasses store the configuration
			for(hostType : fragment.hostTypes.get(hostClass)){ // Every HostInstance
				for(hostInstance : hostType.instances){
					// Initialize list of forbidden targets
					var List<HostInstance> forbiddenTargetInstances = Lists.newArrayList;
					// Add itself to the forbidden targets
					forbiddenTargetInstances.add(hostInstance); 
					// Calculate the number of new communication links
					val numberOfCommLinks = hostClass.numberOfCommunicationLines.randInt(fragment.random); 
					// Create communication links
					for(i : 0 ..< numberOfCommLinks){
						// Randomize target node
						val targetHostInstance = hostInstances.randElementExcept(forbiddenTargetInstances, fragment.random);
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