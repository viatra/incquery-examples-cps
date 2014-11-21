package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface IPhase<FragmentType> {
	def Iterable<IOperation<FragmentType>> getOperations(FragmentType fragment);
}