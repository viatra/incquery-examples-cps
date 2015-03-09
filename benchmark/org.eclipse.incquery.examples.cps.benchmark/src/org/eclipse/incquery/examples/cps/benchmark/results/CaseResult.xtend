package org.eclipse.incquery.examples.cps.benchmark.results

import org.eclipse.xtend.lib.annotations.Accessors
import org.codehaus.jackson.annotate.JsonProperty

class CaseResult {
	
	@JsonProperty("Scenario")
	@Accessors static String scenario
	
	@JsonProperty("Tool")
	@Accessors static String tool
	
	@JsonProperty("Size")
	@Accessors static int size
	
	@JsonProperty("RunIndex")
	@Accessors static int runIndex
	
	@JsonProperty("Case")
	@Accessors static String caseName
}