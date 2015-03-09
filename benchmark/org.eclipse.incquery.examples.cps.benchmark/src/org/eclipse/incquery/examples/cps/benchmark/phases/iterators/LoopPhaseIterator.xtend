package org.eclipse.incquery.examples.cps.benchmark.phases.iterators

import java.util.Iterator
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase
import org.eclipse.incquery.examples.cps.benchmark.phases.LoopPhase

class LoopPhaseIterator implements Iterator<BenchmarkPhase>{
	
	protected LoopPhase loopPhase
	protected Iterator<BenchmarkPhase> iterator
	
	new(LoopPhase loopPhase){
		this.loopPhase = loopPhase
		iterator = loopPhase.phase.iterator
	}
	
	override hasNext() {
		loopPhase.condition
	}
	
	override next() {
		if (loopPhase.condition){
			return iterator.next
		}
		return null
	}
	
	override remove() {
		throw new UnsupportedOperationException("Unsupported operation")
	}
	
	
}