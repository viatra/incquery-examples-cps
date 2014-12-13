package org.eclipse.incquery.examples.cps.xform.m2t.monitor

import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import java.util.Set

@Data class DeploymentChangeDelta {
	public Set<DeploymentElement> appeared
	public Set<DeploymentElement> updated
	public Set<DeploymentElement> disappeared
	public boolean deploymentChanged
}