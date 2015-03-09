package org.eclipse.incquery.examples.cps.benchmark.phases.iterators

import java.util.Iterator
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase

class AtomicPhaseIterator implements Iterator<BenchmarkPhase>{
	
	AtomicPhase atomic
	boolean hasNext
	
	new(AtomicPhase phase){
		atomic = phase
		hasNext = true
	}
	
	override hasNext() {
		hasNext
	}
	
	override next() {
		hasNext = false
		atomic
	}
	
	override remove() {
		throw new UnsupportedOperationException("Unsupported operation")
	}
	
}