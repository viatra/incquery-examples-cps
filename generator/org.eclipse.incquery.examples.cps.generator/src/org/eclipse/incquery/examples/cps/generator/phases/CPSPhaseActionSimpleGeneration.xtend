package org.eclipse.incquery.examples.cps.generator.phases

import com.google.common.collect.Lists
import com.google.common.collect.Sets
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.StateMachine
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Transition
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.operations.ActionGenerationOperation
import org.eclipse.incquery.examples.cps.generator.queries.PossibleReceiverTypeMatcher
import org.eclipse.incquery.examples.cps.generator.queries.ReachableAppTypesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.ReceiverTransitionMatcher
import org.eclipse.incquery.examples.cps.generator.queries.TransitionsMatcher
import org.eclipse.incquery.examples.cps.planexecutor.api.IPhase
import org.eclipse.incquery.examples.cps.generator.operations.DeleteTransitionWithoutAction
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import com.google.common.collect.ImmutableList

class CPSPhaseActionSimpleGeneration implements IPhase<CPSFragment>{
	
	private extension RandomUtils randUtil = new RandomUtils;
	private extension Logger logger = Logger.getLogger("cps.generator.impl.CPSPhaseActionGeneration");
	
	public static String WAIT_METHOD_NAME = "waitForSignal";
	public static String SEND_METHOD_NAME = "sendSignal";
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		for(appClass : fragment.applicationTypes.keySet){
			var appTypes = fragment.applicationTypes.get(appClass);
			if(appTypes != null){
				for(appType : appTypes){
					for(transition : appType.behavior.states.map[outgoingTransitions].flatten){
						// Generate Action or not
						if(appClass.probabilityOfActionGeneration.randBooleanWithPercentageOfTrue(fragment.random)){
							// Generate action
							if(appClass.probabilityOfSendAction.randBooleanWithPercentageOfTrue(fragment.random)){
								val action = SEND_METHOD_NAME;
								debug(action)
								operations.add(new ActionGenerationOperation(action, transition));
							}else{
								val action = WAIT_METHOD_NAME;
								debug(action)
								operations.add(new ActionGenerationOperation(action, transition));
							}
						}
					}
				}
			}
		}
		
		return operations;
	}
	
}