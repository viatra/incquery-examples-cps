package org.eclipse.incquery.examples.cps.generator.phases

import com.google.common.collect.Lists
import java.util.List
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.operations.HostInstanceCommunicatesWithOperation
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.planexecutor.api.IPhase
import org.eclipse.incquery.examples.cps.generator.queries.HostInstancesMatcher

class CPSPhaseHostCommunication implements IPhase<CPSFragment>{
	
	private extension RandomUtils randUtil = new RandomUtils;
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
	
		val hostInstances = HostInstancesMatcher.on(fragment.engine).allValuesOfhostInstance.toList;

		// TODO optimize it!
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