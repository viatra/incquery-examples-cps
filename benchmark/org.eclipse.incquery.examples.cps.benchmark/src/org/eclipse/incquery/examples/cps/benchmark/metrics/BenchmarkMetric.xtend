package org.eclipse.incquery.examples.cps.benchmark.metrics

import org.eclipse.xtend.lib.annotations.Accessors

abstract class BenchmarkMetric {
	
	@Accessors protected String name
	
	new(String name){
		this.name = name
	}
	
	override toString(){
		return name + " " + getValue()
	}
	
	def String getValue()
	
}