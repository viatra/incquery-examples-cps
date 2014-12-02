package org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt

import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableSet
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.queries.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules.ApplicationRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules.HostRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.util.PerJobFixedPriorityConflictResolver
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.api.ExecutionSchema
import org.eclipse.incquery.runtime.evm.specific.ExecutionSchemas
import org.eclipse.incquery.runtime.evm.specific.Schedulers

import static com.google.common.base.Preconditions.*
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules.StateMachineRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.qrt.rules.StateRules

class CPS2DeploymentTransformationQrt {

	extension Logger logger = Logger.getLogger("cps.xform.m2m.expl.incr")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance

	ExecutionSchema schema = null

	def execute(CPSToDeployment mapping, IncQueryEngine engine) {
		checkArgument(mapping != null, "Mapping cannot be null!")
		checkArgument(mapping.cps != null, "CPS not defined in mapping!")
		checkArgument(mapping.deployment != null, "Deployment not defined in mapping!")
		checkArgument(engine != null, "Engine cannot be null!")

		info(
			'''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')

		debug("Preparing queries on engine.")
		val watch = Stopwatch.createStarted
		prepare(engine)
		debug('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

		debug("Preparing transformation rules.")
		watch.reset.start
		
		val rulesBuilder = ImmutableSet.builder
		rulesBuilder.addAll(HostRules.getRules(engine))
		rulesBuilder.addAll(ApplicationRules.getRules(engine))
		rulesBuilder.addAll(StateMachineRules.getRules(engine));
		rulesBuilder.addAll(StateRules.getRules(engine));
		val rules = rulesBuilder.build
		
		val schedulerFactory = Schedulers.getIQEngineSchedulerFactory(engine)
		schema = ExecutionSchemas.createIncQueryExecutionSchema(engine, schedulerFactory)

		val fpr = new PerJobFixedPriorityConflictResolver

		rules.forEach [
			fpr.setPriority(ruleSpecification, priority)
			schema.addRule(it.ruleSpecification)
		]

		schema.conflictResolver = fpr;
		
		debug('''Prepared transformation rules («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

		debug("Initial execution of transformation rules.")
		watch.reset.start
		schema.startUnscheduledExecution
		debug('''Initial execution of transformation rules finished («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}

	def dispose() {
		schema?.dispose
	}

}
