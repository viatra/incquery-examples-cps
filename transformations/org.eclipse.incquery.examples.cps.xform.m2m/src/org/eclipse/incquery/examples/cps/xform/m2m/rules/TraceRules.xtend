package org.eclipse.incquery.examples.cps.xform.m2m.rules

import org.eclipse.incquery.examples.cps.xform.m2m.IllegalTraceMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.Jobs
import org.eclipse.incquery.runtime.evm.specific.Lifecycles
import org.eclipse.incquery.runtime.evm.specific.Rules
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum

class TraceRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new IllegalTraceRemoval(engine).specification
		}
	}
}

class IllegalTraceRemoval extends AbstractRule<IllegalTraceMatch> {
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getSpecification() {
		Rules.newMatcherRuleSpecification(
			illegalTrace,
			Lifecycles.getDefault(false, false),
			#{appearedJob}
		)
	}
	
	private def getAppearedJob() {
		Jobs.newStatelessJob(IncQueryActivationStateEnum.APPEARED, [IllegalTraceMatch match |
			val cpsElements = match.trace.cpsElements
			debug('''Removing illegal trace for CPS elements: «FOR e : cpsElements SEPARATOR ", "»«e.id»«ENDFOR»''')
			rootMapping.traces -= match.trace
			debug('''Removed illegal trace''')
		])
	}
	
}