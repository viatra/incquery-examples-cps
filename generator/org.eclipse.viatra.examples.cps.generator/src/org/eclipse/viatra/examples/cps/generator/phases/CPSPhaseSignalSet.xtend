package org.eclipse.incquery.examples.cps.generator.phases

import com.google.common.collect.Lists
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.operations.SignalCalculationOperation
import org.eclipse.incquery.examples.cps.planexecutor.api.IPhase

class CPSPhaseSignalSet implements IPhase<CPSFragment>{
	
	override getOperations(CPSFragment fragment) {
		Lists.newArrayList(new SignalCalculationOperation());
	}
	
}