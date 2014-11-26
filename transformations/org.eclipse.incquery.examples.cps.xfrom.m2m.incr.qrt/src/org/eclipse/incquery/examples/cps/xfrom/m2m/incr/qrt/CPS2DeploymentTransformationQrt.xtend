package org.eclipse.incquery.examples.cps.xfrom.m2m.incr.qrt

import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xfrom.m2m.incr.qrt.queries.CpsXformM2M
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.evm.api.ExecutionSchema

import static com.google.common.base.Preconditions.*

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
	}
	
	def dispose() {
		
	}
	
}
