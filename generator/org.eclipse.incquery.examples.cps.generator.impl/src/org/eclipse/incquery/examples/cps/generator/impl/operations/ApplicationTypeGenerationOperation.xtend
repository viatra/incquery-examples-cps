package org.eclipse.incquery.examples.cps.generator.impl.operations

import com.google.common.collect.Lists
import java.util.List
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.State
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class ApplicationTypeGenerationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
	val AppClass applicationClass;
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	
	new(AppClass applicationClass){
		this.applicationClass = applicationClass;
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		// Generate ApplicationTypes
		val numberOfAppTypes = applicationClass.numberOfAppTypes.randInt(fragment.random);
		
		for(i : 0 ..< numberOfAppTypes){
			val appTypeId = "simple.cps.app." + applicationClass.name + i;
			val appType = fragment.modelRoot.prepareApplicationTypeWithId(appTypeId);
			fragment.addApplicationType(applicationClass, appType);
			
			// Add StateMachine to ApplicationType
			val stateName = appTypeId + ".sm"+i;
			val sm = appType.prepareStateMachine(stateName);
		
			// States
			val numberOfStates = applicationClass.numberOfStates.randInt(fragment.random);
			val List<State> states = Lists.newArrayList();
			for(s : 0 ..< numberOfStates){
				states.add(sm.prepareState(stateName + ".s"+s));
			}
			
			// Transitions
			val numberOfTransactions = applicationClass.numberOfTrannsitions.randInt(fragment.random);
			for(t : 0 ..< numberOfTransactions){
				val startNode = new MinMaxData(0, numberOfStates-1).randInt(fragment.random);
				val endNode = new MinMaxData(0, numberOfStates-1).randIntExcept(startNode, fragment.random);
				
				states.get(startNode).prepareTransition(states.get(startNode).id + ".t"+t, states.get(endNode));
			}
			
		}

		

		true;
	}
	
}