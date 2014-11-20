package org.eclipse.incquery.examples.cps.generator.impl.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.impl.utils.RandomUtils
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Transition

class ActionGenerationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
	
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	private String action;
	private Transition transition;
	
	new(String action, Transition transition){
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
		this.action = action;
		this.transition = transition;
	}
	
	override execute(CPSFragment fragment) {
		transition.setAction(action);
		
		true;
	}
	
}