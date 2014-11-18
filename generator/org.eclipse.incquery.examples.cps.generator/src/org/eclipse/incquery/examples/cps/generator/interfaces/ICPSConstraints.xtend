package org.eclipse.incquery.examples.cps.generator.interfaces

import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorConstraints

interface ICPSConstraints extends IGeneratorConstraints {
	def MinMaxData<Integer> getNumberOfSignals();
	def Iterable<AppClass> getApplicationClasses();
	def Iterable<HostClass> getHostClasses();
}