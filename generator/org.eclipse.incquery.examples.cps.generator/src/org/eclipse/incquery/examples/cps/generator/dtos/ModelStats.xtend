package org.eclipse.incquery.examples.cps.generator.dtos

import org.apache.log4j.Logger

class ModelStats {
	public static String DELIMITER = ";"
	
	public int eObjects = 0;
	public int eReferences = 0;
	
	def logCSV(Logger csvLogger, String name) {	
		csvLogger.info(name + DELIMITER + eObjects + DELIMITER + eReferences)
	}
}