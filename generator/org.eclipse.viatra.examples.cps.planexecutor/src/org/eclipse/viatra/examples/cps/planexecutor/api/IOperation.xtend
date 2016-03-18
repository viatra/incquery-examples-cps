package org.eclipse.viatra.examples.cps.planexecutor.api

interface IOperation<FragmentType> {
	def boolean execute(FragmentType fragment);
}