package org.eclipse.incquery.examples.cps.generator.dtos

import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorConstraints

@Data
class GeneratorInput<ModelType extends EObject> extends GeneratorConfiguration<ModelType> {
	long seed;
	IGeneratorConstraints constraints;
	
	new(long seed, IGeneratorConstraints constraints, ModelType modelRoot) {
		this._seed = seed;
		this._constraints = constraints;
		this.modelRoot = modelRoot;
	}
}
