package org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine
import org.eclipse.viatra.query.runtime.emf.EMFScope

class ViatraTransformation extends CPSTransformationWrapper {
	
	CPS2DeploymentTransformationViatra xform 
	AdvancedViatraQueryEngine engine
	
	
	
	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedViatraQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource.resourceSet));
		xform = new CPS2DeploymentTransformationViatra
		xform.initialize(cps2dep,engine)

	}
	
	override executeTransformation() {
		
		xform.execute
		debug("VIATRA based Query Result Traceability transformation is incremental")
	}
	
	override cleanupTransformation() {
		if(xform != null){
			xform.dispose
		}
		if(engine != null){
			engine.dispose
		}
		xform = null
		engine = null
	}
	
}