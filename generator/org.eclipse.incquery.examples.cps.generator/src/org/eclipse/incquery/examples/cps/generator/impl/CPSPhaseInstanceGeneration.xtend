package org.eclipse.incquery.examples.cps.generator.impl

import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.operations.HostInstanceGenerationOperation
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class CPSPhaseInstanceGeneration implements IGenratorPhase<CyberPhysicalSystem, CPSFragment>{
	
	private extension RandomUtils randUtil = new RandomUtils;
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		// ApplicationInstances
		// TODO generate Application Instances

		
		// Generate Host Instances
		// HostClasses
		for(hostClass : fragment.hostTypes.keys){
			val types = fragment.hostTypes.get(hostClass);
			// HostTypes
			if(types != null){
				for(type : types){
					operations.add(new HostInstanceGenerationOperation(hostClass, type));
				}
			}
			
		}
		
		return operations;
	}
	
}