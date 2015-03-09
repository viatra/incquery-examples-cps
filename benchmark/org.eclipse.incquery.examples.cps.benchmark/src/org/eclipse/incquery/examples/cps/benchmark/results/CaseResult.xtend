package org.eclipse.incquery.examples.cps.benchmark.results

import org.eclipse.xtend.lib.annotations.Accessors
import org.codehaus.jackson.annotate.JsonProperty

class CaseResult {
	
	@JsonProperty("Scenario")
	@Accessors String scenario
	
	@JsonProperty("Tool")
	@Accessors String tool
	
	@JsonProperty("Size")
	@Accessors int size
	
	@JsonProperty("RunIndex")
	@Accessors int runIndex
	
	@JsonProperty("Case")
	@Accessors String caseName
}