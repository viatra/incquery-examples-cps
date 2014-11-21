package org.eclipse.incquery.examples.cps.planexecutor.api

interface IPhase<FragmentType> {
	def Iterable<IOperation<FragmentType>> getOperations(FragmentType fragment);
}