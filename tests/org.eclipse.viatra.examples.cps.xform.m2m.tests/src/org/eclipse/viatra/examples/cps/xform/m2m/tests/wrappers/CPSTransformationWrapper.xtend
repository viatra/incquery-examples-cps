package org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers

import org.apache.log4j.Logger
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment

abstract class CPSTransformationWrapper {
	protected extension Logger logger = Logger.getLogger("cps.xform.CPSTransformationWrapper")
	
	def void initializeTransformation(CPSToDeployment cps2dep)
	
	def void executeTransformation()
	
	def void cleanupTransformation()
}