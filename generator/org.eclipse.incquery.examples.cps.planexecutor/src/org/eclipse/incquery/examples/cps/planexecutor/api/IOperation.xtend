package org.eclipse.incquery.examples.cps.planexecutor.api

interface IOperation<FragmentType> {
	def boolean execute(FragmentType fragment);
}