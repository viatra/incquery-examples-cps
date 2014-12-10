package org.eclipse.incquery.examples.cps.xform.m2t.listener

import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import java.util.Set

@Data class DeploymentChangeDelta {
	Set<DeploymentElement> appeared
	Set<DeploymentElement> updated
	Set<DeploymentElement> disappeared
	boolean deploymentChanged
}