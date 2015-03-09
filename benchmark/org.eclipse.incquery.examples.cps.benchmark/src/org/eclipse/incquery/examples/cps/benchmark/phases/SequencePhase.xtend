package org.eclipse.incquery.examples.cps.benchmark.phases

import java.util.LinkedList
import org.eclipse.xtend.lib.annotations.Accessors

class SequencePhase implements BenchmarkPhase{
	
	@Accessors(PUBLIC_GETTER, NONE) protected LinkedList<BenchmarkPhase> phases
	
	new(){
		phases = new LinkedList<BenchmarkPhase>
	}
	
	override iterator() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def getSize(){
		phases.size()
	}
	
}