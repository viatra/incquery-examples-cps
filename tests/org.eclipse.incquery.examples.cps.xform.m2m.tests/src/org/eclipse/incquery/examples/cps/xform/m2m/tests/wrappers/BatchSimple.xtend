package org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.batch.simple.CPS2DeploymentBatchTransformationSimple

class BatchSimple extends CPSTransformationWrapper {

	val xform = new CPS2DeploymentBatchTransformationSimple

	override initializeTransformation(CPSToDeployment cps2dep) {
	}

	override executeTransformation() {
	}

	override cleanupTransformation() {
	}

}
