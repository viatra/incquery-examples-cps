package org.eclipse.incquery.examples.cps.planexecutor.api

interface Initializer<FragmentType> {
	def FragmentType getInitialFragment();
}