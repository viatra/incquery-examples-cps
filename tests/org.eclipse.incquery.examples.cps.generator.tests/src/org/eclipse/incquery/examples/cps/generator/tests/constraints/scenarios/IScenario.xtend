package org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios

import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints

interface IScenario {
	def ICPSConstraints getConstraintsFor(int countOfElements);
}