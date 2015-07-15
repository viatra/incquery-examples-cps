package org.eclipse.incquery.examples.cps.integration.messages

import java.util.ArrayList
import java.util.List
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord
import org.eclipse.viatra.emf.mwe2integration.IMessageFactory
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.exceptions.InvalidParameterTypeException

class M2TOutputMessageFactory implements IMessageFactory<List<M2TOutputRecord>, M2TOutputMessage> {
	override boolean isValidParameter(Object parameter) {
		var List<M2TOutputRecord> list = (parameter as List<M2TOutputRecord>)
		if(list != null){
			return true
		}else {
			return false
		}
	}

	override M2TOutputMessage createMessage(Object parameter) throws InvalidParameterTypeException {
		if (isValidParameter(parameter)) {
			return new M2TOutputMessage(parameter as List<M2TOutputRecord>)
		}
		return new M2TOutputMessage(new ArrayList<M2TOutputRecord>())
	}

}
