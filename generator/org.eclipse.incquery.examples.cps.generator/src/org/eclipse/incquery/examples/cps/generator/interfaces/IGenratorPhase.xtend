package org.eclipse.incquery.examples.cps.generator.interfaces

import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment

interface IGenratorPhase<ModelType extends EObject, FragmentType extends GeneratorFragment<ModelType>> {
	def Iterable<IGeneratorOperation<ModelType, FragmentType>> getOperations(FragmentType fragment);
}