package org.eclipse.viatra.examples.cps.generator.operations

import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.generator.utils.RandomUtils
import org.eclipse.viatra.examples.cps.planexecutor.api.IOperation

class ActionGenerationOperation implements IOperation<CPSFragment> {
	
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