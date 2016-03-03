package org.eclipse.viatra.examples.cps.planexecutor.api

interface Initializer<FragmentType> {
	def FragmentType getInitialFragment();
}