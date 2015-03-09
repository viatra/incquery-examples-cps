package org.eclipse.incquery.examples.cps.benchmark.phases

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.IterationPhaseIterator

class IterationPhase implements BenchmarkPhase{
	
	@Accessors protected int maxIteration
	@Accessors protected BenchmarkPhase phase
	
	new(int maxIteration){
		this.maxIteration = maxIteration
	}
	
	override iterator() {
		new IterationPhaseIterator(this)
	}
	
}