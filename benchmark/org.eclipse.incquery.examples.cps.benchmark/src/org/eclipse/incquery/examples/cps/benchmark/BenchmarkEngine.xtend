package org.eclipse.incquery.examples.cps.benchmark

import org.eclipse.incquery.examples.cps.benchmark.results.BenchmarkResult
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult

class BenchmarkEngine {
	
	@Accessors(PUBLIC_GETTER, NONE) extension BenchmarkResult benchmarkResult
	
	new(){
		benchmarkResult = new BenchmarkResult
	}
	
	def runBenchmark(BenchmarkScenario scenario, DataToken token){
		var sequence = 1
		scenario.buildScenario
		token.init
		
		while(scenario.hasNextPhase){
			val AtomicPhase phase = scenario.nextPhase
			if (phase != null){
				val PhaseResult phaseResult = new PhaseResult
				phaseResult.name = phase.phaseName
				
				phase.execute(token, phaseResult)
				
				if (phaseResult.metricResults.size > 0){
					phaseResult.sequence = sequence
					addResults(phaseResult)
					sequence++
				}
			}
		}
		
	publishResults
	token.destroy
	}
}