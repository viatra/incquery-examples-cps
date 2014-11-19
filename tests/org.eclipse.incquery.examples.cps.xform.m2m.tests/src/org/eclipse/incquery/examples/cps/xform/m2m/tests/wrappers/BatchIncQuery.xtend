package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xfrom.m2m.batch.eiq.CPS2DeploymentBatchTransformationEiq
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine

class BatchIncQuery extends CPSTransformationWrapper {

	CPS2DeploymentBatchTransformationEiq xform
	AdvancedIncQueryEngine engine

	override initializeTransformation(CPSToDeployment cps2dep) {
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(cps2dep.eResource.resourceSet);
		xform = new CPS2DeploymentBatchTransformationEiq(cps2dep, engine)
	}

	override executeTransformation() {
		xform.execute
	}

	override cleanupTransformation() {
		if (engine != null) {
			engine.dispose
		}
	}

}
