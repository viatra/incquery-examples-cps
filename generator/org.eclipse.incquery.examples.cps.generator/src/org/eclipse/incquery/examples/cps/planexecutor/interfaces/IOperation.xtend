package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface IOperation<FragmentType extends IFragment> {
	def boolean execute(FragmentType fragment);
}