package org.eclipse.incquery.examples.cps.planexecutor

import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.planexecutor.api.IPlan
import org.eclipse.incquery.examples.cps.planexecutor.api.Initializer

class PlanExecutor<FragmentType, InputType extends Initializer<FragmentType>> {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Generator")
	
	def process(IPlan<FragmentType> plan, InputType input){
		val FragmentType fragment = input.getInitialFragment;
		
		continueProcessing(plan, fragment)
		
		return fragment;
	}
	
	def continueProcessing(IPlan<FragmentType> plan, FragmentType fragment) {
		plan.phases.forEach[phase, i| 
			debug("<< Begin Phase: " + phase.class.simpleName + " >>");
			val phaseSw = Stopwatch.createStarted;
			phase.getOperations(fragment).forEach[operation, j|
				try{
					debug("< OPERATION " + operation.class.simpleName + " >");
					operation.execute(fragment);
					debug("<-------------------- END OPERATION ----------------------->");
				}catch(Exception e){
					info(e.message);
				}
			]
			phaseSw.stop;
			info("<< Done "+ phase.class.simpleName + " phase in "+ phaseSw.elapsed(TimeUnit.MILLISECONDS) +" ms >>");
		]
	}
	
}