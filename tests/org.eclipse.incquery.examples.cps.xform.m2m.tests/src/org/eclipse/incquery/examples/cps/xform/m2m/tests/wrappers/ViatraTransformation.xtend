package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.emf.EMFScope

class ViatraTransformation extends CPSTransformationWrapper {
	
	CPS2DeploymentTransformationViatra xform 
	AdvancedIncQueryEngine engine
	
	
	
	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource.resourceSet));
		xform = new CPS2DeploymentTransformationViatra
		xform.initialize(cps2dep,engine)

	}
	
	override executeTransformation() {
		
		xform.execute
		debug("VIATRA based Query Result Traceability transformation is incremental")
	}
	
	override cleanupTransformation() {
		if(engine != null){
			engine.dispose
		}
	}
	
}