package org.eclipse.viatra.examples.cps.xform.m2m.incr.qrt.util

import org.eclipse.viatra.query.runtime.api.IPatternMatch
import org.eclipse.viatra.transformation.evm.api.RuleSpecification

class PriorityRuleSpecification<Match extends IPatternMatch> {	
	@Property RuleSpecification<Match> ruleSpecification	
	@Property int priority	
}
