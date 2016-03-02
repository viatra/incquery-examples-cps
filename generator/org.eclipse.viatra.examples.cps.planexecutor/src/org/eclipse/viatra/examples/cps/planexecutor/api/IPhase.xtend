package org.eclipse.viatra.examples.cps.planexecutor.api

interface IPhase<FragmentType> {
	def Iterable<IOperation<FragmentType>> getOperations(FragmentType fragment);
}