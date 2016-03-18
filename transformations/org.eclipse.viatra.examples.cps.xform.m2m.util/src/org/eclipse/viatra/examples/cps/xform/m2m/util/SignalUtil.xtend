package org.eclipse.viatra.examples.cps.xform.m2m.util

import java.util.regex.Pattern

class SignalUtil {
	
	static val waitPattern = Pattern.compile("^waitForSignal\\((.*)\\)$")
	static val sendPattern = Pattern.compile("^sendSignal\\((.*),(.*)\\)$")
	
	static def isSend(String action) {
		sendPattern.matcher(action).matches
	}
	
	static def isWait(String action) {
		waitPattern.matcher(action).matches
	}
	
	@Pure
	static def getAppId(String action){
		sendPattern.getGroupOfMatch(action, 1)
	}
	
	@Pure
	static def getSignalId(String action) {
		val sendId = sendPattern.getGroupOfMatch(action, 2)
		if(sendId == null) {
			waitPattern.getGroupOfMatch(action, 1)
		} else {
			sendId
		}
	}
	
	private static def getGroupOfMatch(Pattern pattern, String action, int group){
		val matcher = pattern.matcher(action)
		if(matcher.matches) {
			matcher.group(group).trim
		}
	}
}