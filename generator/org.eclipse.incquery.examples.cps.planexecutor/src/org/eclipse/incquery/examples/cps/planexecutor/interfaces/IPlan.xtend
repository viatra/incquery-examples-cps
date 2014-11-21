package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface IPlan<FragmentType extends IFragment, InputType extends IInput> {
	def void addPhase(IPhase<FragmentType> phase);
	def Iterable<IPhase<FragmentType>> getPhases();
	def FragmentType getInitialFragment(InputType input);
}