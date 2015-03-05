package org.eclipse.incquery.examples.cps.performance.tests.results

import java.util.List
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.codehaus.jackson.annotate.JsonProperty

class BenchmarkResult {

	@JsonProperty("PhaseResults")
	List<PhaseResult> phaseResults
	
	@Accessors var static String path = "./results/json/"
	@Accessors var static boolean publish = true
	
	new(){
		phaseResults = new ArrayList()
	}
	
	def addResults(PhaseResult result){
		phaseResults.add(result)
	}
	
	def publishResults(){
		var String filePath = path + "testResult.json"
		if (publish){
			ResultSerializer.serializeToJson(this, filePath);
		}
	}
}