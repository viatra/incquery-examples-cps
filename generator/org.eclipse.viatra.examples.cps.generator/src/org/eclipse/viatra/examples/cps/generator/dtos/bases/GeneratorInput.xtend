package org.eclipse.viatra.examples.cps.generator.dtos.bases

import org.eclipse.emf.ecore.EObject
import org.eclipse.viatra.examples.cps.generator.interfaces.IConstraints
import org.eclipse.viatra.examples.cps.planexecutor.api.Initializer
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment

@Data
abstract class GeneratorInput<ModelType extends EObject> extends GeneratorConfiguration<ModelType> implements Initializer<CPSFragment> {
	long seed;
	IConstraints constraints;
	
	new(long seed, IConstraints constraints, ModelType modelRoot) {
		this._seed = seed;
		this._constraints = constraints;
		this.modelRoot = modelRoot;
	}
	
}
