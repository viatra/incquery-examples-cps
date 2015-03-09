package org.eclipse.incquery.examples.cps.benchmark.phases.iterators

import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase
import java.util.Iterator
import org.eclipse.incquery.examples.cps.benchmark.phases.IterationPhase

class IterationPhaseIterator implements Iterator<BenchmarkPhase>{
	
	int maxIteration
	int iteration
	IterationPhase iterationPhase
	Iterator<BenchmarkPhase> iterator
	
	new(IterationPhase iterationPhase){
		this.iterationPhase = iterationPhase
		iteration = 0
		maxIteration = iterationPhase.maxIteration
		iterator = iterationPhase.phase.iterator
	}
	
	override hasNext() {
		return iteration < maxIteration
	}
	
	override next() {
		if (iteration == maxIteration){
			iteration = 0
		}
		val atomic = iterator.next
		if (!iterator.hasNext){
			iteration++
		}
		return atomic
	}
	
	override remove() {
		throw new UnsupportedOperationException("Unsupported operation")
	}
	
}