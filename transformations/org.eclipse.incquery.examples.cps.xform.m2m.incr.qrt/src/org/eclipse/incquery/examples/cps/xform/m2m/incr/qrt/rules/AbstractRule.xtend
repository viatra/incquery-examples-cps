package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.util.PriorityRuleSpecification
import org.eclipse.viatra.query.runtime.api.IPatternMatch
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine

import static com.google.common.base.Preconditions.*

abstract class AbstractRule<M extends IPatternMatch> {

	protected extension Logger logger = Logger.getLogger("cps.xform.AbstractRule")
	protected extension DeploymentFactory depFactory = DeploymentFactory.eINSTANCE
	protected extension TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE
	protected extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	protected ViatraQueryEngine engine

	new(ViatraQueryEngine engine) {
		this.engine = engine
		debug('''Creating rule «this.class.simpleName»''')
	}

	def PriorityRuleSpecification<M> getSpecification()

	def getRootMapping() {
		val matcher = cpsXformM2M.getMappedCPS(engine)
		checkState(matcher.countMatches == 1, "Incorrect number of CPSToDeployment mappings!")
		return matcher.oneArbitraryMatch.cps2dep
	}

	def <Match extends M> createPriorityRuleSpecification() {
		new PriorityRuleSpecification<Match>	
	}
}