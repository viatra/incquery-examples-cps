package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.aggr.CPS2DeploymentPartialBatchTransformation
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine

class PartialBatch extends CPSTransformationWrapper {

	CPS2DeploymentPartialBatchTransformation xform
	AdvancedIncQueryEngine engine

	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		xform = new CPS2DeploymentPartialBatchTransformation(cps2dep, engine)
	}

	override executeTransformation() {
		xform.execute
	}

	override cleanupTransformation() {
		if (engine != null) {
			engine.dispose
		}
		xform = null
	}

}
