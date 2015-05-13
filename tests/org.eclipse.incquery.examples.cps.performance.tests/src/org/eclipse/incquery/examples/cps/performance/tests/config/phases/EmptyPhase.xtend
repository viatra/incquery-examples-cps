package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.results.PhaseResult

class EmptyPhase extends AtomicPhase {

	new(String phaseName) {
		super("Empty" + phaseName)
	}

	override execute(DataToken token, PhaseResult phaseResult) {
	}

}