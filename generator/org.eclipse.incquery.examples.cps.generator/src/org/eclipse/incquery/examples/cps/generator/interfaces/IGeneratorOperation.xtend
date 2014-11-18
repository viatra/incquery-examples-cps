package org.eclipse.incquery.examples.cps.generator.interfaces

import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment
import org.eclipse.emf.ecore.EObject

interface IGeneratorOperation<ModelType extends EObject, FragmentType extends GeneratorFragment<ModelType>> {
	def boolean execute(FragmentType fragment);
}