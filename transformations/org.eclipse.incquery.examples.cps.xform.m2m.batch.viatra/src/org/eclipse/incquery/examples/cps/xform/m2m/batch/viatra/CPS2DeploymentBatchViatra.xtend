package org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra

import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.patterns.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.rules.RuleProvider
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.specific.RuleEngines
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation

import static com.google.common.base.Preconditions.*

class CPS2DeploymentBatchViatra {
	extension Logger logger = Logger.getLogger("cps.xform.m2m.batch.viatra")
	
	/* Transformation-related extensions */

	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	extension RuleProvider ruleProvider
	extension BatchTransformation transformation
	extension BatchTransformationStatements statements
	
	CPSToDeployment mapping
	IncQueryEngine engine
	
	private var initialized = false;

	def initialize(CPSToDeployment cps2dep, IncQueryEngine engine) {
		checkArgument(cps2dep != null, "Mapping cannot be null!")
		checkArgument(cps2dep.cps != null, "CPS not defined in mapping!")
		checkArgument(cps2dep.deployment != null, "Deployment not defined in mapping!")
		checkArgument(engine != null, "Engine cannot be null!")
		
		if (!initialized) {
			this.mapping = cps2dep
			this.engine = engine
			
			val ruleEngine = RuleEngines::createIncQueryRuleEngine(engine)
			transformation = BatchTransformation::forRuleEngine(ruleEngine, AdvancedIncQueryEngine.from(engine))
			statements = new BatchTransformationStatements(transformation)
			
			debug("Preparing queries on engine.")
			var watch = Stopwatch.createStarted
			prepare(engine)
			debug('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms''')
			
			debug('''Preparing transformation rules.''')
			watch = Stopwatch.createStarted
			ruleProvider = new RuleProvider(engine, cps2dep)
			
			debug('''Prepared transformation rules («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			initialized = true
		}
		
	}
	
	def execute(){
		debug('''Executing transformation on: Cyber-physical system: «mapping.cps.id»''')
		mapping.traces.clear
		mapping.deployment.hosts.clear
		
		hostRule.fireAllCurrent
		applicationRule.fireAllCurrent
		stateMachineRule.fireAllCurrent
		stateRule.fireAllCurrent
		transitionRule.fireAllCurrent
		actionRule.fireAllCurrent		
	}
}