package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment

abstract class CPSTransformationWrapper {
	protected extension Logger logger = Logger.getLogger("cps.xform.CPS2DepTest")
	
	def void initializeTransformation(CPSToDeployment cps2dep)
	
	def void executeTransformation()
	
	def void cleanupTransformation()
}