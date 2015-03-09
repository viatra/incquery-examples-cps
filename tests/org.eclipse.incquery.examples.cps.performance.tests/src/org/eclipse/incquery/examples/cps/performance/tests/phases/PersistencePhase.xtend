package org.eclipse.incquery.examples.cps.performance.tests.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.OptionalPhase
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.DataToken
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken

class PersistencePhase extends OptionalPhase{
	
	new(){
		phase = new PersistenceAtomicPhase("Persistence")
	}
	
	override condition() {
		PropertiesUtil.persistResults
	}
}


class PersistenceAtomicPhase extends AtomicPhase{
	
	new(String name) {
		super(name)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		cpsToken.cps2dep.eResource.resourceSet.resources.forEach[save(null)]
	}
	
	
}