package org.eclipse.incquery.examples.cps.performance.tests.phases

import eu.mondo.sam.core.phases.OptionalPhase
import eu.mondo.sam.core.phases.AtomicPhase;
import eu.mondo.sam.core.DataToken;
import eu.mondo.sam.core.results.PhaseResult;
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