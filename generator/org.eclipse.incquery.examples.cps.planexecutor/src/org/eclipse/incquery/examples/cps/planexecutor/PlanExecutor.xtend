package org.eclipse.incquery.examples.cps.planexecutor

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.planexecutor.exceptions.ModelGeneratorException
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IPlan

class PlanExecutor<FragmentType, InputType> {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Generator")
	
	def generate(IPlan<FragmentType, InputType> plan, InputType input){
		val FragmentType fragment = plan.getInitialFragment(input);
		
		plan.phases.forEach[phase, i| 
			info("<< PHASE " + phase.class.simpleName + " >>");
			phase.getOperations(fragment).forEach[operation, j|
				try{
					info("< OPERATION " + operation.class.simpleName + " >");
					operation.execute(fragment);
					info("<-------------------- END OPERATION ----------------------->");
				}catch(ModelGeneratorException e){
					info(e.message);
				}
			]
			info("<<===================== END PHASE ========================>>");
		]
		
		return fragment;
	}
	
}