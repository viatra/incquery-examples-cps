package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.exceptions

class CPSGeneratorException extends Exception {
	new(String msg){
		super(msg)
	}
	
	new(String msg, Throwable t){
		super(msg, t)
	}
}