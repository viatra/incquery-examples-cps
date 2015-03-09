package org.eclipse.incquery.examples.cps.benchmark.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.AtomicPhaseIterator
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.benchmark.DataToken
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult

abstract class AtomicPhase implements BenchmarkPhase{
	
	@Accessors(PUBLIC_GETTER, NONE) protected String phaseName
	
	new(String name){
		this.phaseName = name
	}
	
	override iterator() {
		new AtomicPhaseIterator(this)
	}
	
	def DataToken execute(DataToken token, PhaseResult phaseResult)
	
}