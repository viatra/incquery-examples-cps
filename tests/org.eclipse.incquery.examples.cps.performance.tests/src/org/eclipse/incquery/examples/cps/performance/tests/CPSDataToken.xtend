package org.eclipse.incquery.examples.cps.performance.tests

import eu.mondo.sam.core.DataToken;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.performance.tests.integration.ToolchainPerformanceTest
import org.eclipse.incquery.examples.cps.performance.tests.integration.ToolchainPerformanceTest.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.integration.ToolchainPerformanceTest.TransformationType

@Accessors
class CPSDataToken implements DataToken{
	
	GeneratorType generatorType
	
	// TODO is this needed?
	TransformationType transformationType
	
	String scenarioName
	
	CPSToDeployment cps2dep
	
	ICPSConstraints constraints
	
	String instancesDirPath
	
	int seed
	
	int size
	
	int modificationIndex
	
	CPSTransformationWrapper xform
	
	override init() {
		modificationIndex = 1
	}
	
	override destroy() {
		
	}
	
	
	
}