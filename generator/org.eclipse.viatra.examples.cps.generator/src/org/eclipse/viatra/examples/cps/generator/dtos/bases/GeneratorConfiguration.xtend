package org.eclipse.viatra.examples.cps.generator.dtos.bases

import org.eclipse.emf.ecore.EObject

class GeneratorConfiguration<ModelType extends EObject> {
	public ModelType modelRoot;
}