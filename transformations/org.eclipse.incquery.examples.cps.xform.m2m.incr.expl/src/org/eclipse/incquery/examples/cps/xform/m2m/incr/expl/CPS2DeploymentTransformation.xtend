package org.eclipse.incquery.examples.cps.xform.m2m.incr.expl

import com.google.common.base.Stopwatch
import com.google.common.collect.ImmutableSet
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.queries.CpsXformM2M
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules.ApplicationRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules.HostRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules.StateMachineRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules.StateRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules.TransitionRules
import org.eclipse.incquery.examples.cps.xform.m2m.incr.expl.rules.TriggerRules
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.transformation.evm.api.ExecutionSchema
import org.eclipse.viatra.transformation.evm.specific.ExecutionSchemas
import org.eclipse.viatra.transformation.evm.specific.Schedulers

import static com.google.common.base.Preconditions.*

class CPS2DeploymentTransformation {
	
	extension Logger logger = Logger.getLogger("cps.xform.m2m.expl.incr")
	extension CpsXformM2M cpsXformM2M = CpsXformM2M.instance
	
	ExecutionSchema schema = null
	
	CPSToDeployment cps2dep
	ViatraQueryEngine engine
	
	def initialize(CPSToDeployment mapping, ViatraQueryEngine iqEngine) {
		checkArgument(mapping != null, "Mapping cannot be null!")
		checkArgument(mapping.cps != null, "CPS not defined in mapping!")
		checkArgument(mapping.deployment != null, "Deployment not defined in mapping!")
		checkArgument(iqEngine != null, "Engine cannot be null!")
		
		this.cps2dep = mapping
		this.engine = iqEngine
		
		debug("Preparing queries on engine.")
		val watch = Stopwatch.createStarted
		prepare(engine)
		info('''Prepared queries on engine («watch.stop.elapsed(TimeUnit.MILLISECONDS)» ms)''')
		
	}
	
	def execute() {
		
		if(schema == null){
			info('''
				Executing transformation on:
					Cyber-physical system: «cps2dep.cps.id»''')
				
			debug("Preparing transformation rules.")
			val watch = Stopwatch.createStarted
			
			val rulesBuilder = ImmutableSet.builder
			rulesBuilder.addAll(HostRules.getRules(engine))
			rulesBuilder.addAll(ApplicationRules.getRules(engine))
			rulesBuilder.addAll(StateMachineRules.getRules(engine))
			rulesBuilder.addAll(StateRules.getRules(engine))
			rulesBuilder.addAll(TransitionRules.getRules(engine))
			rulesBuilder.addAll(TriggerRules.getRules(engine))
	//		rulesBuilder.addAll(TraceRules.getRules(engine))
			val rules = rulesBuilder.build
			
			val schedulerFactory = Schedulers.getIQEngineSchedulerFactory(engine)
			schema = ExecutionSchemas.createIncQueryExecutionSchema(engine, schedulerFactory)
			rules.forEach[
				schema.addRule(it)
			]
			
			info('''Prepared transformation rules («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			
			debug("Initial execution of transformation rules.")
			watch.reset.start
			schema.startUnscheduledExecution
			info('''Initial execution of transformation rules finished («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			
		}
	}
	
	def dispose() {
		if(schema != null){
			schema.dispose
		}
		engine = null
		schema = null
		cps2dep = null
	}
}