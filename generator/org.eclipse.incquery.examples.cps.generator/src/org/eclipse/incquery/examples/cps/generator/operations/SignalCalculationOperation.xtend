package org.eclipse.incquery.examples.cps.generator.operations

import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.planexecutor.api.IOperation

class SignalCalculationOperation implements IOperation<CPSFragment> {
	
	private extension RandomUtils randUtil
	
	new(){
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		var constraints = fragment.input.constraints as ICPSConstraints;
		var numberOfSignals = constraints.numberOfSignals.randInt(fragment.random);
		fragment.setNumberOfSignals(numberOfSignals);	
		return true;
	}
	
}