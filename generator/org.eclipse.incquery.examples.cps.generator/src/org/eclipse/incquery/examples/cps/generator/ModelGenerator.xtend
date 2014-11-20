package org.eclipse.incquery.examples.cps.generator

import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput
import org.eclipse.incquery.examples.cps.generator.exceptions.ModelGeneratorException
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorPlan

class ModelGenerator<ModelType extends EObject, FragmentType extends GeneratorFragment<ModelType>> {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Generator")
	
	def generate(IGeneratorPlan<ModelType, FragmentType> plan, GeneratorInput<ModelType> input){
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