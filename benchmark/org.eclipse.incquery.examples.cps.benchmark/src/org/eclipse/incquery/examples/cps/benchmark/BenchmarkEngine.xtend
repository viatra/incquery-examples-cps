package org.eclipse.incquery.examples.cps.benchmark

import org.eclipse.incquery.examples.cps.benchmark.results.BenchmarkResult
import org.eclipse.xtend.lib.annotations.Accessors

class BenchmarkEngine {
	
	@Accessors(PUBLIC_GETTER, NONE)BenchmarkResult benchmarkResult
	
	new(){
		benchmarkResult = new BenchmarkResult
	}
	
	def runBenchmark(){
		
		var iteration = 1
		
	}
}