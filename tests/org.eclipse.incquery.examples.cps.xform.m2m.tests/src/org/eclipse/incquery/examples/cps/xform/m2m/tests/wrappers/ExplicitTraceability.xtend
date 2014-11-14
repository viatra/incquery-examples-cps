package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.CPS2DeploymentTransformation
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine

class ExplicitTraceability extends CPSTransformationWrapper {
	
	val xform = new CPS2DeploymentTransformation
	AdvancedIncQueryEngine engine
	
	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		xform.execute(cps2dep, engine)
	}
	
	override executeTransformation() {
		info("ExplicitTraceability is incremental")
	}
	
	override cleanupTransformation() {
		if(xform != null){
			xform.dispose
		}
		if(engine != null){
			engine.dispose
		}
	}
	
}