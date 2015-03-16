package org.eclipse.incquery.examples.cps.performance.tests

import eu.mondo.sam.core.DataToken;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper

class CPSDataToken implements DataToken{
	
	@Accessors String scenarioName
	
	@Accessors CPSToDeployment cps2dep
	
	@Accessors ICPSConstraints constraints
	
	@Accessors String instancesDirPath
	
	@Accessors int seed
	
	@Accessors int size
	
	@Accessors int modificationIndex
	
	@Accessors CPSTransformationWrapper xform
	
	override init() {
		modificationIndex = 1
	}
	
	override destroy() {
		
	}
	
	
	
}