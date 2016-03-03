package org.eclipse.viatra.examples.cps.integration.messages

import org.eclipse.viatra.examples.cps.xform.m2t.monitor.DeploymentChangeDelta
import org.eclipse.viatra.integration.mwe2.IMessage

class ChangeDeltaMessage implements IMessage<DeploymentChangeDelta> {
	DeploymentChangeDelta parameter

	new(DeploymentChangeDelta parameter) {
		super()
		this.parameter = parameter
	}

	override DeploymentChangeDelta getParameter() {
		return parameter
	}

	override void setParameter(DeploymentChangeDelta parameter) {
		this.parameter = parameter
	}

}
