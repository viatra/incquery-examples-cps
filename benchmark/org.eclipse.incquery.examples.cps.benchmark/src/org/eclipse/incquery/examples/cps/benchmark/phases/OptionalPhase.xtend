package org.eclipse.incquery.examples.cps.benchmark.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.OptionalPhaseIterator

abstract class OptionalPhase extends ConditionalPhase{
	
	override iterator(){
		new OptionalPhaseIterator(this)
	}
}