package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface IOperation<FragmentType> {
	def boolean execute(FragmentType fragment);
}