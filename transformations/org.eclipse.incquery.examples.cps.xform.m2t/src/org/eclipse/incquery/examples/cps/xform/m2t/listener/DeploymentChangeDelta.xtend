package org.eclipse.incquery.examples.cps.xform.m2t.listener

import org.eclipse.incquery.examples.cps.deployment.DeploymentElement

@Data class DeploymentChangeDelta {
	Iterable<DeploymentElement> changedElements
}