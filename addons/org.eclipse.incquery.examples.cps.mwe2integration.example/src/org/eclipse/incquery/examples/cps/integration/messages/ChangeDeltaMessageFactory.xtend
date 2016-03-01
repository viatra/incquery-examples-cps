package org.eclipse.incquery.examples.cps.integration.messages

import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta
import org.eclipse.viatra.integration.mwe2.IMessageFactory
import org.eclipse.viatra.integration.mwe2.mwe2impl.exceptions.InvalidParameterTypeException

class ChangeDeltaMessageFactory implements IMessageFactory<DeploymentChangeDelta, ChangeDeltaMessage> {
	override boolean isValidParameter(Object parameter) {
		if (parameter instanceof DeploymentChangeDelta) {
			return true
		}
		return false
	}

	override ChangeDeltaMessage createMessage(Object parameter) throws InvalidParameterTypeException {
		if (isValidParameter(parameter)) {
			return new ChangeDeltaMessage(parameter as DeploymentChangeDelta)
		}
		return null
	}
}
