package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.CPS2DeploymentTransformationQrt
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.emf.EMFScope

class QueryResultTraceability extends CPSTransformationWrapper {
	
	CPS2DeploymentTransformationQrt xform 
	AdvancedIncQueryEngine engine
	
	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource.resourceSet));
		xform = new CPS2DeploymentTransformationQrt
		xform.initialize(cps2dep, engine)
	}
	
	override executeTransformation() {
		xform.execute
		debug("Query Result Traceability transformation is incremental")
	}
	
	override cleanupTransformation() {
		if(xform != null){
			xform.dispose
		}
		if(engine != null){
			engine.dispose
		}
		engine = null
		xform = null
	}
}