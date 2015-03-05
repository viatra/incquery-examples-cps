package org.eclipse.incquery.examples.cps.performance.tests.results

import org.codehaus.jackson.map.ObjectMapper
import org.codehaus.jackson.map.SerializationConfig
import java.io.File

class ResultSerializer {
	
	def static serializeToJson(BenchmarkResult result, String filePath){
		val mapper = new ObjectMapper()
		mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false)
		mapper.configure(SerializationConfig.Feature.INDENT_OUTPUT, true)
		mapper.configure(SerializationConfig.Feature.AUTO_DETECT_FIELDS, false)
		mapper.configure(SerializationConfig.Feature.AUTO_DETECT_GETTERS, false)
		
		mapper.writeValue(new File(filePath), result)
	}
}