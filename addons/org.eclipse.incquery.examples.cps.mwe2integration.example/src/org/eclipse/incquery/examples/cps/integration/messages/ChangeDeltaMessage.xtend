package org.eclipse.incquery.examples.cps.integration.messages

import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta
import org.eclipse.viatra.emf.mwe2integration.IMessage

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
