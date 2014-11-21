package org.eclipse.incquery.examples.cps.generator.interfaces

import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData

interface ICPSConstraints extends IConstraints {
	def MinMaxData<Integer> getNumberOfSignals();
	def Iterable<AppClass> getApplicationClasses();
	def Iterable<HostClass> getHostClasses();
	def String getName();
}	