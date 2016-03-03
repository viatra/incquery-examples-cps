package org.eclipse.viatra.examples.cps.integration.messages

import java.util.List
import org.eclipse.viatra.examples.cps.xform.m2t.api.M2TOutputRecord
import org.eclipse.viatra.integration.mwe2.IMessage

class M2TOutputMessage implements IMessage<List<M2TOutputRecord>> {
	List<M2TOutputRecord> parameter

	new(List<M2TOutputRecord> parameter) {
		super()
		this.parameter = parameter
	}

	override List<M2TOutputRecord> getParameter() {
		return parameter
	}

	override void setParameter(List<M2TOutputRecord> parameter) {
		this.parameter = parameter
	}

}
