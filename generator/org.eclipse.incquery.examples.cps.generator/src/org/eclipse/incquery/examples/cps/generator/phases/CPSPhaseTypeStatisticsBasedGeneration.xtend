package org.eclipse.incquery.examples.cps.generator.phases

import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.operations.ApplicationTypeStatisticsBasedGenerationOperation
import org.eclipse.incquery.examples.cps.generator.operations.HostTypeGenerationOperation
import org.eclipse.incquery.examples.cps.planexecutor.api.IPhase

class CPSPhaseTypeStatisticsBasedGeneration implements IPhase<CPSFragment>{
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		val constraints = fragment.input.constraints as ICPSConstraints;
		
		// ApplicationTypes
		constraints.applicationClasses.forEach[appClass, i | 
			operations.add(new ApplicationTypeStatisticsBasedGenerationOperation(appClass));
		]
		
		// HostTypes
		constraints.hostClasses.forEach[hostClass, i | 
			operations.add(new HostTypeGenerationOperation(hostClass));
		]
		
		return operations;
	}
	
}