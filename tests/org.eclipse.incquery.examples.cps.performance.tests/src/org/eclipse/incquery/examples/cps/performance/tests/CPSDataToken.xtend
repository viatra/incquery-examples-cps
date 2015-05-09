package org.eclipse.incquery.examples.cps.performance.tests

import eu.mondo.sam.core.DataToken
import org.eclipse.core.resources.IFolder
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.performance.tests.integration.ToolchainPerformanceTest.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.integration.ToolchainPerformanceTest.TransformationType
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class CPSDataToken implements DataToken{
	
	GeneratorType generatorType
	TransformationType transformationType
	String scenarioName
	CPSToDeployment cps2dep
	ICPSConstraints constraints
	String instancesDirPath
	DeploymentChangeMonitor changeMonitor
	ICPSGenerator codeGenerator 
	IFolder srcFolder
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