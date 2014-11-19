package org.eclipse.incquery.examples.cps.generator.impl

import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.operations.ApplicationInstanceGenerationOperation
import org.eclipse.incquery.examples.cps.generator.impl.operations.HostInstanceGenerationOperation
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase

class CPSPhaseInstanceGeneration implements IGenratorPhase<CyberPhysicalSystem, CPSFragment>{
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		// ApplicationInstances
		for(appClass : fragment.applicationTypes.keySet){
			val appTypes = fragment.applicationTypes.get(appClass);
			if(appTypes != null){
				for(appType : appTypes){
					operations.add(new ApplicationInstanceGenerationOperation(appClass, appType));
				}			
			}
		}

		
		// Generate Host Instances
		// HostClasses
		for(hostClass : fragment.hostTypes.keySet){
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