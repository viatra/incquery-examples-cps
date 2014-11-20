package org.eclipse.incquery.examples.cps.planexecutor.generator

import org.eclipse.emf.ecore.EObject
import java.util.Random
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IFragment

class GeneratorFragment<ModelType extends EObject> extends GeneratorConfiguration<ModelType> implements IFragment {
	val GeneratorInput<ModelType> input;
	
	val Random rand;
	
	new(GeneratorInput<ModelType> input) {
		this.input = input;
		this.modelRoot = input.modelRoot;
		if(input != null){
			this.rand = new Random(input.seed);
		}else{
			this.rand = new Random(0);
		}
		
	}
	
	def getInput(){
		return input;
	}
	
	def getSeed(){
		if(input != null){
			return input.seed;
		}
		return 0;
	}
	
	def getRandom(){
		return rand;
	}
	
}