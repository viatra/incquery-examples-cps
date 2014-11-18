package org.eclipse.incquery.examples.cps.generator.exceptions

import java.lang.Exception

class ModelGeneratorException extends Exception {
	new(String msg){
		super(msg);
	}
	
	new(String msg, Throwable throwable){
		super(msg, throwable);
	}
}