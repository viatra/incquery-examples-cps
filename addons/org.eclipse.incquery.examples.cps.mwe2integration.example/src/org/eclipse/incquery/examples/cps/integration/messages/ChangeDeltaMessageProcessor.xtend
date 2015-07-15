package org.eclipse.incquery.examples.cps.integration.messages

import java.security.InvalidParameterException
import org.eclipse.incquery.examples.cps.integration.M2TDistributedTransformationStep
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta
import org.eclipse.viatra.emf.mwe2integration.IMessage
import org.eclipse.viatra.emf.mwe2integration.IMessageProcessor
import org.eclipse.viatra.emf.mwe2integration.ITransformationStep

class ChangeDeltaMessageProcessor implements IMessageProcessor<DeploymentChangeDelta, ChangeDeltaMessage> {
	protected ITransformationStep parent

	override ITransformationStep getParent() {
		return parent
	}

	override void setParent(ITransformationStep parent) {
		this.parent = parent
	}

	override void processMessage(IMessage<? extends Object> message) throws InvalidParameterException {
		if (message instanceof ChangeDeltaMessage) {
			var ChangeDeltaMessage event = (message as ChangeDeltaMessage)
			if (parent instanceof M2TDistributedTransformationStep) {
				var M2TDistributedTransformationStep m2tparent = (parent as M2TDistributedTransformationStep)
				m2tparent.delta = event.getParameter()
			}
		}
	}
}
