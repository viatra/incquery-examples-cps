package org.eclipse.incquery.examples.cps.benchmark.phases

import org.eclipse.xtend.lib.annotations.Accessors

abstract class ConditionalPhase implements BenchmarkPhase{
	
	@Accessors protected BenchmarkPhase phase
	
	def boolean condition()
}