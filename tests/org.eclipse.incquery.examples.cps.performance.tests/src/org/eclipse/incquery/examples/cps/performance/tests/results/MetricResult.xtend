package org.eclipse.incquery.examples.cps.performance.tests.results

import org.eclipse.xtend.lib.annotations.Accessors
import org.codehaus.jackson.annotate.JsonProperty

class MetricResult {
	
	@JsonProperty("MetricName")
	@Accessors String name
	
	@JsonProperty("MetricValue")
	@Accessors String value
	
	new(String name, String value){
		this.name = name
		this.value = value
	}
		
}