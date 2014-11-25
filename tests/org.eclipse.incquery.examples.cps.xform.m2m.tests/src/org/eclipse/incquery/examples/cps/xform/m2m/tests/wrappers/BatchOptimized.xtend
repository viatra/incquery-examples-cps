package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.batch.optimized.CPS2DeploymentBatchTransformationOptimized

class BatchOptimized extends CPSTransformationWrapper {

	CPS2DeploymentBatchTransformationOptimized xform

	override initializeTransformation(CPSToDeployment cps2dep) {
		xform = new CPS2DeploymentBatchTransformationOptimized(cps2dep)
	}

	override executeTransformation() {
		xform.execute
	}

	override cleanupTransformation() {
	}

}
