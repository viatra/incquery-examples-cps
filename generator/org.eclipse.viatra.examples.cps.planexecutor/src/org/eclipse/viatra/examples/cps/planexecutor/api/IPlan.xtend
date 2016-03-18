package org.eclipse.incquery.examples.cps.planexecutor.api

interface IPlan<FragmentType> {
	def void addPhase(IPhase<FragmentType> phase);
	def Iterable<IPhase<FragmentType>> getPhases();
}