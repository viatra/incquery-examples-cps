package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints

class StatisticsBasedGenerationPhase extends GenerationPhase {

	new(String name, ICPSConstraints constraints) {
		super(name, constraints)
	}

	override protected getPlan() {
		CPSPlanBuilder.buildCharacteristicBasedPlan
	}

}