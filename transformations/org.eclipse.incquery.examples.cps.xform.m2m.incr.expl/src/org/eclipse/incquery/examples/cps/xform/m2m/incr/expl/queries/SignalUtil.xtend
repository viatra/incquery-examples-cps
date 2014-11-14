package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries

import java.util.regex.Pattern

class SignalUtil {
	
	static def isSend(String action) {
		Pattern.matches("^sendSignal\\((.*),(.*)\\)$", action)
	}
	
	static def isWait(String action) {
		Pattern.matches("^waitForSignal\\((.*)\\)$", action)
	}
	
	static def getAppId(String action){
		val matcher = Pattern.compile("^waitForSignal\\((.*)\\)$").matcher(action)
		if(matcher.matches) {
			matcher.group(1)
		}
	}
	
	static def getSignalId(String action) {
		val matcher = Pattern.compile("^waitForSignal\\((.*)\\)$").matcher(action)
		if(matcher.matches) {
			matcher.group(2)
		}
	}
}