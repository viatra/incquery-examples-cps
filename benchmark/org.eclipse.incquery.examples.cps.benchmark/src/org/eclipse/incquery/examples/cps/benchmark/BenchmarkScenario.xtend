package org.eclipse.incquery.examples.cps.benchmark

abstract class BenchmarkScenario {
	
	def void buildScenario()
	def DataToken getDataToken()
}