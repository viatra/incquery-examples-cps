package org.eclipse.viatra.examples.cps.generator.dtos

class ModelStats {
	public static String DELIMITER = ";"
	
	public int eObjects = 0;
	public int eReferences = 0;
	
	def getCSVEValues() {	
		eObjects + DELIMITER + eReferences
	}
}