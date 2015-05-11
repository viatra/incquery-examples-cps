package org.eclipse.incquery.examples.cps.performance.tests.cases

import org.eclipse.incquery.examples.cps.performance.tests.phases.ClientServerModificationPhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.GenerationPhase

class ClientServerCase extends BenchmarkCase {
	override getGenerationPhase(String name) {
		return new GenerationPhase(name)
	}
	
	override getModificationPhase(String name) {
		return new ClientServerModificationPhase(name)
	}
}