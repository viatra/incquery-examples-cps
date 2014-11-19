package org.eclipse.incquery.examples.cps.generator.impl.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class SignalCalculationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
	
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