package org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra

import com.google.common.base.Stopwatch
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.patterns.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.rules.RuleProvider
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.util.PerJobFixedPriorityConflictResolver
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.viatra.emf.runtime.transformation.eventdriven.EventDrivenTransformation

import static com.google.common.base.Preconditions.*
import java.util.concurrent.TimeUnit

class CPS2DeploymentTransformationViatra {

	extension Logger logger = Logger.getLogger("cps.xform.m2m.incr.viatra")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	extension RuleProvider ruleProvider

	CPSToDeployment cps2dep
	IncQueryEngine engine
	EventDrivenTransformation transform
	

	private var initialized = false;

	def initialize(CPSToDeployment cps2dep, IncQueryEngine engine) {
		checkArgument(cps2dep != null, "Mapping cannot be null!")
		checkArgument(cps2dep.cps != null, "CPS not defined in mapping!")
		checkArgument(cps2dep.deployment != null, "Deployment not defined in mapping!")
		checkArgument(engine != null, "Engine cannot be null!")

		if (!initialized) {
			this.cps2dep = cps2dep
			this.engine = engine

			debug("Preparing queries on engine.")
			var watch = Stopwatch.createStarted
			prepare(engine)
			info('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

			info("Preparing transformation rules.")
			watch = Stopwatch.createStarted
			ruleProvider = new RuleProvider(engine,cps2dep)
			registerRulesWithCustomPriorities
			info('''Prepared transformation rules («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			initialized = true
		}
	}

	
	def execute() {
		debug('''Executing transformation on: Cyber-physical system: «cps2dep.cps.id»''')
		transform.executionSchema.startUnscheduledExecution

	}

	private def registerRulesWithCustomPriorities() {
		val fixedPriorityResolver = new PerJobFixedPriorityConflictResolver
		fixedPriorityResolver.setPriority(hostRule.ruleSpecification, 1)
		fixedPriorityResolver.setPriority(applicationRule.ruleSpecification, 2)
		fixedPriorityResolver.setPriority(stateMachineRule.ruleSpecification, 3)
		fixedPriorityResolver.setPriority(stateRule.ruleSpecification, 4)
		fixedPriorityResolver.setPriority(transitionRule.ruleSpecification, 5)
		fixedPriorityResolver.setPriority(triggerRule.ruleSpecification, 6)

		transform = EventDrivenTransformation.forEngine(engine).
			setConflictResolver(fixedPriorityResolver).
			addRule(hostRule).
			addRule(applicationRule).
			addRule(stateMachineRule).
			addRule(stateRule).
			addRule(transitionRule).
			addRule(triggerRule).			
			create()
	}

	def dispose(){
		if(transform != null){
			transform.executionSchema.dispose
		}
		transform = null
		return
	}
}
