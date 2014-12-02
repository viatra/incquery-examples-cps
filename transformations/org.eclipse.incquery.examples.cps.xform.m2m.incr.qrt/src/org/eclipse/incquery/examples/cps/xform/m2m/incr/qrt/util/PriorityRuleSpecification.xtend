package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.util

import org.eclipse.incquery.runtime.api.IPatternMatch
import org.eclipse.incquery.runtime.evm.api.RuleSpecification

class PriorityRuleSpecification<Match extends IPatternMatch> {	
	@Property RuleSpecification<Match> ruleSpecification	
	@Property int priority	
}
