package org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine
import org.eclipse.viatra.examples.cps.xform.m2m.incr.aggr.CPS2DeploymentPartialBatchTransformation
import org.eclipse.viatra.query.runtime.emf.EMFScope

class PartialBatch extends CPSTransformationWrapper {

	CPS2DeploymentPartialBatchTransformation xform
	AdvancedViatraQueryEngine engine

	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedViatraQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource.resourceSet));
		xform = new CPS2DeploymentPartialBatchTransformation(cps2dep, engine)
	}

	override executeTransformation() {
		xform.execute
	}

	override cleanupTransformation() {
		if(xform != null){
			xform.dispose
		}
		if (engine != null) {
			engine.dispose
		}
		engine = null
		xform = null
	}

}
