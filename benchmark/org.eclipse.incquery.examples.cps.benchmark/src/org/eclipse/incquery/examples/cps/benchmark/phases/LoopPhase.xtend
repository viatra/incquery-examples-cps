package org.eclipse.incquery.examples.cps.benchmark.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.LoopPhaseIterator

abstract class LoopPhase extends ConditionalPhase{
	
	override iterator(){
		new LoopPhaseIterator(this)
	}
}