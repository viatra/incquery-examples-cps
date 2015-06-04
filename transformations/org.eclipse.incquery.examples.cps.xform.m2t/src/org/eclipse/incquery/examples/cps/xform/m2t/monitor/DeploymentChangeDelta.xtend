package org.eclipse.incquery.examples.cps.xform.m2t.monitor

import java.util.Map
import java.util.Set
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement

@Data class DeploymentChangeDelta {
	public Set<DeploymentElement> appeared
	public Set<DeploymentElement> updated
	public Set<DeploymentElement> disappeared
	public Map<DeploymentElement, String> oldNamesForDeletion
	public boolean deploymentChanged
}