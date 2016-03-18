package org.eclipse.viatra.examples.cps.planexecutor.api

interface IPlan<FragmentType> {
	def void addPhase(IPhase<FragmentType> phase);
	def Iterable<IPhase<FragmentType>> getPhases();
}