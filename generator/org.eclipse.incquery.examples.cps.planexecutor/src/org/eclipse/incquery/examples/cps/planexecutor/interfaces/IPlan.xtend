package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface IPlan<FragmentType, InputType> {
	def void addPhase(IPhase<FragmentType> phase);
	def Iterable<IPhase<FragmentType>> getPhases();
}