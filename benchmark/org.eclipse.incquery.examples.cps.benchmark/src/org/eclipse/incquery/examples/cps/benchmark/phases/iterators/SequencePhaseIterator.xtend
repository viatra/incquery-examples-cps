package org.eclipse.incquery.examples.cps.benchmark.phases.iterators

import java.util.Iterator
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase
import org.eclipse.incquery.examples.cps.benchmark.phases.SequencePhase

class SequencePhaseIterator implements Iterator<BenchmarkPhase>{
	
	int index
	SequencePhase sequencePhase
	Iterator<BenchmarkPhase> iterator
	
	new(SequencePhase phase){
		this.sequencePhase = phase
		this.iterator = phase.phases.first.iterator
	}
	
	override hasNext() {
		var size = sequencePhase.size
		return index < size
	}
	
	override next() {
		val size = sequencePhase.size
		//if returned the last AtomicPhase before
		if (index == size){
			index = 0
			iterator = sequencePhase.phases.first.iterator
		}
		
		val atomic = iterator.next
		if (!iterator.hasNext){
			index++
			if (index < size){
				iterator = sequencePhase.phases.get(index).iterator
			}
		}
		return atomic
	}
	
	override remove() {
		throw new UnsupportedOperationException("UnSupported operation")
	}
	
}