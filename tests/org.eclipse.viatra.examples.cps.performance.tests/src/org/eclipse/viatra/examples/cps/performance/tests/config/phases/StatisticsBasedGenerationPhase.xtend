package org.eclipse.viatra.examples.cps.performance.tests.config.phases

import org.eclipse.viatra.examples.cps.generator.CPSPlanBuilder
import org.eclipse.viatra.examples.cps.generator.interfaces.ICPSConstraints

class StatisticsBasedGenerationPhase extends GenerationPhase {

	new(String name, ICPSConstraints constraints) {
		super(name, constraints)
	}

	override protected getPlan() {
		CPSPlanBuilder.buildCharacteristicBasedPlan
	}

}