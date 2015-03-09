package org.eclipse.incquery.examples.cps.benchmark

import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase
import java.util.Iterator
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase

abstract class BenchmarkScenario {
	
	Iterator<BenchmarkPhase> iterator
	@Accessors protected BenchmarkPhase rootPhase
	
	def void buildScenario()
	
	def boolean hasNextPhase(){
		if (iterator == null){
			iterator = rootPhase.iterator
		}
		iterator.hasNext
	}
	
	def AtomicPhase nextPhase(){
		if (iterator == null){
			iterator = rootPhase.iterator
		}
		iterator.next as AtomicPhase
	}
}