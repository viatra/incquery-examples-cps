package org.eclipse.incquery.examples.cps.generator.impl.phases

import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.operations.SignalCalculationOperation
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IPhase

class CPSPhaseSignalSet implements IPhase<CPSFragment>{
	
	override getOperations(CPSFragment fragment) {
		Lists.newArrayList(new SignalCalculationOperation());
	}
	
}