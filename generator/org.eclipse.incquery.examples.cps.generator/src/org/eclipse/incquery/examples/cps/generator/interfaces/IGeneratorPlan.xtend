package org.eclipse.incquery.examples.cps.generator.interfaces

import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput

interface IGeneratorPlan<ModelType extends EObject, FragmentType extends GeneratorFragment<ModelType>> {
	def void addPhase(IGenratorPhase<ModelType, FragmentType> phase);
	def Iterable<IGenratorPhase<ModelType, FragmentType>> getPhases();
	def FragmentType getInitialFragment(GeneratorInput<ModelType> input);
}