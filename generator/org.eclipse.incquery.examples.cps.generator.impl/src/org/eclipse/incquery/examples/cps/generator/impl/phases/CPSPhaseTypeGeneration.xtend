package org.eclipse.incquery.examples.cps.generator.impl.phases

import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.impl.operations.ApplicationTypeGenerationOperation
import org.eclipse.incquery.examples.cps.generator.impl.operations.HostTypeGenerationOperation
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase

class CPSPhaseTypeGeneration implements IGenratorPhase<CyberPhysicalSystem, CPSFragment>{
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		val constraints = fragment.input.constraints as ICPSConstraints;
		
		// ApplicationTypes
		constraints.applicationClasses.forEach[appClass, i | 
			operations.add(new ApplicationTypeGenerationOperation(appClass));
		]
		
		// HostTypes
		constraints.hostClasses.forEach[hostClass, i | 
			operations.add(new HostTypeGenerationOperation(hostClass));
		]
		
		return operations;
	}
	
}