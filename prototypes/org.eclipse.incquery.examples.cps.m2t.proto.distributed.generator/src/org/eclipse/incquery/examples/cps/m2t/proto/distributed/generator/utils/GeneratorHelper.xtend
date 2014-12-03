package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.utils

class GeneratorHelper {
	
	def static purify(String ipAddress){
		return ipAddress.replaceAll("[^A-Za-z0-9 ]", "")
	}
	 
}