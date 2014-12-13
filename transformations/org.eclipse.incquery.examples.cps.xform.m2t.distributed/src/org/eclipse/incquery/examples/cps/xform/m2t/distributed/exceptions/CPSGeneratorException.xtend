package org.eclipse.incquery.examples.cps.xform.m2t.distributed.exceptions

class CPSGeneratorException extends Exception {
	new(String msg){
		super(msg)
	}
	
	new(String msg, Throwable t){
		super(msg, t)
	}
}