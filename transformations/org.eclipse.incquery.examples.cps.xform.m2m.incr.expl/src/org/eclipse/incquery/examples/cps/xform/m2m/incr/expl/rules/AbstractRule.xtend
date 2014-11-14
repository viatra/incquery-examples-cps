package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.CpsXformM2M
import org.eclipse.incquery.runtime.api.IPatternMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.api.RuleSpecification

import static com.google.common.base.Preconditions.*

abstract class AbstractRule<M extends IPatternMatch> {
	
	protected extension Logger logger = Logger.getLogger("cps.xform.AbstractRule")
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	protected extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	protected IncQueryEngine engine	
	
	new(IncQueryEngine engine){
		this.engine = engine
		debug('''Creating rule «this.class.simpleName»''')
	}
	
	def RuleSpecification<M> getSpecification()
	
	def getRootMapping() {
		val matcher = cpsXformM2M.getMappedCPS(engine)
		checkState(matcher.countMatches == 1, "Multiple CPSToDeployment mappings!")
		return matcher.oneArbitraryMatch.cps2dep
	}
}