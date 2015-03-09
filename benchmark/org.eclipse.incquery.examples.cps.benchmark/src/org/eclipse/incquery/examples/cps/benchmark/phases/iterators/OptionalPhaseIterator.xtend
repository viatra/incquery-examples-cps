package org.eclipse.incquery.examples.cps.benchmark.phases.iterators

import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase
import java.util.Iterator
import org.eclipse.incquery.examples.cps.benchmark.phases.OptionalPhase

class OptionalPhaseIterator implements Iterator<BenchmarkPhase>{
	
	OptionalPhase optionalPhase
	Iterator<BenchmarkPhase> iterator
	boolean hasNext
	
	new(OptionalPhase optionalPhase){
		this.optionalPhase = optionalPhase
		hasNext = true
		iterator = optionalPhase.phase.iterator
	}
	
	override hasNext() {
		hasNext
	}
	
	override next() {
		if (optionalPhase.condition){
			val atomic = iterator.next
			if (!iterator.hasNext){
				hasNext = false
			}
			return atomic
		}
		hasNext = false
		return null
	}
	
	override remove() {
		throw new UnsupportedOperationException("Unsupported operation")
	}
	
}