package org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment
import org.eclipse.viatra.examples.cps.xform.m2m.batch.simple.CPS2DeploymentBatchTransformationSimple

class BatchSimple extends CPSTransformationWrapper {

	CPS2DeploymentBatchTransformationSimple xform

	override initializeTransformation(CPSToDeployment cps2dep) {
		xform = new CPS2DeploymentBatchTransformationSimple(cps2dep)
	}

	override executeTransformation() {
		xform.execute
	}

	override cleanupTransformation() {
		if(xform != null){
			xform.dispose
		}
		xform = null
	}

}
