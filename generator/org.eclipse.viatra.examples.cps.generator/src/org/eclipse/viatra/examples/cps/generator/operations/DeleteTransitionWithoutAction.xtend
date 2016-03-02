package org.eclipse.viatra.examples.cps.generator.operations

import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.generator.utils.RandomUtils
import org.eclipse.viatra.examples.cps.planexecutor.api.IOperation
import org.eclipse.viatra.examples.cps.generator.queries.TransitionWithoutActionMatcher
import org.eclipse.emf.ecore.util.EcoreUtil

class DeleteTransitionWithoutAction implements IOperation<CPSFragment> {
	
	CPSFragment fragment
	
	new(CPSFragment fragment){
		this.fragment = fragment;
	}
	
	override execute(CPSFragment fragment) {
		
		val matcher = TransitionWithoutActionMatcher.on(fragment.engine)
		
		matcher.allMatches.forEach[
			EcoreUtil.delete(it.t)
		]
		
		true;
	}
	
}