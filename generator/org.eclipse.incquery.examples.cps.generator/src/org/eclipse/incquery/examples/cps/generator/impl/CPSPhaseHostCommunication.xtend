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
		var List<HostInstance> targetInstances = Lists.newArrayList;
		for(hostClass : fragment.hostInstances.keys){
			for(hostInstance : fragment.hostInstances.get(hostClass)){
				val numberOfCommLinks = hostClass.numberOfCommunicationLines.randInt(fragment.random);
				for(i : 0 ..< numberOfCommLinks){
					val targetHostInstance = fragment.hostInstances.values.randElementExcept(targetInstances, fragment.random);
					targetInstances.add(targetHostInstance);
					operations.add(new HostInstanceCommunicatesWithOperation(hostInstance, targetHostInstance));
				}
			}
		}
		
		return operations;
	}
	
}