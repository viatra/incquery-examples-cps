package org.eclipse.incquery.examples.cps.generator

import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorPlan
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput
import org.eclipse.incquery.examples.cps.generator.exceptions.ModelGeneratorException
import com.google.common.collect.Iterables

class ModelGenerator<ModelType extends EObject, FragmentType extends GeneratorFragment<ModelType>> {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Generator")
	
	def generate(IGeneratorPlan<ModelType, FragmentType> plan, GeneratorInput<ModelType> input){
		val FragmentType fragment = plan.getInitialFragment(input);
		
		plan.phases.forEach[phase, i| 
			phase.getOperations(fragment).forEach[operation, j|
				try{
					operation.execute(fragment);
				}catch(ModelGeneratorException e){
					info(e.message);
				}
			]
		]
		
		return fragment;
	}
	
}