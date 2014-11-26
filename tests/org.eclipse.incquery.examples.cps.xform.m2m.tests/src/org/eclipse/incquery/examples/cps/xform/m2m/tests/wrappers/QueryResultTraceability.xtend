package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.CPS2DeploymentTransformationQrt
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine

class QueryResultTraceability extends CPSTransformationWrapper {
	
	val xform = new CPS2DeploymentTransformationQrt
	AdvancedIncQueryEngine engine
	
	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		xform.execute(cps2dep, engine)
	}
	
	override executeTransformation() {
		debug("Query Result Traceability transformation is incremental")
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