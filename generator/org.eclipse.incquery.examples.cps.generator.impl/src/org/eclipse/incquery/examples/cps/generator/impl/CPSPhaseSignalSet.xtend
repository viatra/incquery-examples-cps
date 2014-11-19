package org.eclipse.incquery.examples.cps.generator.impl

import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.generator.impl.operations.SignalCalculationOperation

class CPSPhaseSignalSet implements IGenratorPhase<CyberPhysicalSystem, CPSFragment>{
	
	override getOperations(CPSFragment fragment) {
		Lists.newArrayList(new SignalCalculationOperation());
	}
	
}