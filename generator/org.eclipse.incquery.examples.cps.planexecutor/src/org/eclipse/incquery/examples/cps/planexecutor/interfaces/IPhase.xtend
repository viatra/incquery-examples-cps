package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface IPhase<FragmentType extends IFragment> {
	def Iterable<IOperation<FragmentType>> getOperations(FragmentType fragment);
}