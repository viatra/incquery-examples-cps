package org.eclipse.incquery.examples.cps.benchmark.phases

import java.util.LinkedList
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.SequencePhaseIterator

class SequencePhase implements BenchmarkPhase{
	
	@Accessors(PUBLIC_GETTER, NONE) protected LinkedList<BenchmarkPhase> phases
	
	new(){
		phases = new LinkedList<BenchmarkPhase>
	}
	
	def addPhase(BenchmarkPhase... phases){
		phases.forEach[phase |
			this.phases.add(phase)
		]
	}
	
	override iterator() {
		new SequencePhaseIterator(this)
	}
	
	def getSize(){
		phases.size()
	}
	
}