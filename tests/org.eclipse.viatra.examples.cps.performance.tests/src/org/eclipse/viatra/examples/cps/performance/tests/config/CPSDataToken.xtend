package org.eclipse.viatra.examples.cps.performance.tests.config

import eu.mondo.sam.core.DataToken
import org.eclipse.core.resources.IFolder
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.viatra.examples.cps.xform.m2t.api.ICPSGenerator
import org.eclipse.viatra.examples.cps.xform.m2t.monitor.DeploymentChangeMonitor
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine

@Accessors
class CPSDataToken implements DataToken{
	
	GeneratorType generatorType
	AdvancedViatraQueryEngine engine
	TransformationType transformationType
	String scenarioName
	CPSToDeployment cps2dep
	String instancesDirPath
	DeploymentChangeMonitor changeMonitor
	ICPSGenerator codeGenerator 
	IFolder srcFolder
	String folderPath
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