package org.eclipse.incquery.examples.cps.benchmark.metrics

class MemoryMetric extends BenchmarkMetric{
	
	var long memory
	
	new(String name) {
		super(name)
	}
	
	override String getValue() {
		Long.toString(memory);
	}
	
	def measure(){
		memory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()
	}
	
}