package org.eclipse.incquery.examples.cps.generator.dtos.scenario

import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints

/**
 * &sum; <sub>Element count of CPS model</sub> &#8776; |HC| * F<sub>H</sub> + |AC| * F<sub>A</sub> * 
 * (2 + F<sub>AI</sub> + F<sub>HI</sub> + F<sub>S</sub> + F<sub>T</sub>)
 * 
 * <ul>
 * 	 <li>HC: HostClass</li>
 * 	 <li>AC: ApplicationClass</li>
 * 	 <li>F<sub>H</sub>: HostType factor</li>
 * 	 <li>F<sub>A</sub>: ApplicationType factor</li>
 * 	 <li>F<sub>AI</sub>: ApplicationInstance factor</li>
 * 	 <li>F<sub>HI</sub>: HostInstance factor</li>
 * 	 <li>F<sub>S</sub>: State factor</li>
 * 	 <li>F<sub>T</sub>: Transition factor</li>
 * </ul>
 * 
 */
interface IScenario {
	def ICPSConstraints getConstraintsFor(int countOfElements);
}