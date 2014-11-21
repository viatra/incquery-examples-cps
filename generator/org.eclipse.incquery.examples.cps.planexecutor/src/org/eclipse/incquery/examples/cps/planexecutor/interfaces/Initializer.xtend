package org.eclipse.incquery.examples.cps.planexecutor.interfaces

interface Initializer<FragmentType> {
	def FragmentType getInitialFragment();
}