package org.eclipse.incquery.examples.cps.benchmark.results

import org.eclipse.incquery.examples.cps.benchmark.metrics.BenchmarkMetric

import java.util.List;
import java.util.ArrayList;
import org.eclipse.xtend.lib.annotations.Accessors
import org.codehaus.jackson.annotate.JsonProperty

class PhaseResult {
	
	@JsonProperty("Name")
	@Accessors String name
	
	@JsonProperty("Sequence")
	@Accessors int sequence
	
	@JsonProperty("Metrics")
	List<MetricResult> metricResults
	
	new(){
		metricResults = new ArrayList<MetricResult>();
	}
	
	def addMetrics(BenchmarkMetric... metrics){
		metrics.forEach[metric | 
			val MetricResult result = new MetricResult(metric.name, metric.value)
			this.metricResults.add(result)
		]
	}
	
	
}