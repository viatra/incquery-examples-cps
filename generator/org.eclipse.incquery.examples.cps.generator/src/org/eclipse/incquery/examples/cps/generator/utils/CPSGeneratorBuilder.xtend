package org.eclipse.incquery.examples.cps.generator.utils

import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor

class CPSGeneratorBuilder {
	
	protected static extension Logger logger = Logger.getLogger("cps.generator.impl.CPSGeneratorBuilder")
	
	def static CPSFragment buildAndGenerateModel(long seed,  ICPSConstraints constraints){
		val CPSModelBuilderUtil mb = new CPSModelBuilderUtil;
		val cps2dep = mb.prepareEmptyModel("testModel"+System.nanoTime);
		
		if(cps2dep != null && cps2dep.cps != null){
			return buildAndGenerateModel(seed, constraints, cps2dep.cps);
		}else{
			info("!!! Error: Cannot create CPS model");
			return new CPSFragment(new CPSGeneratorInput(seed, constraints, null));
		}
	}
	
	def static buildAndGenerateModel(long seed,  ICPSConstraints constraints, CyberPhysicalSystem model){
		val CPSGeneratorInput input = new CPSGeneratorInput(seed, constraints, model);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, CPSGeneratorInput> generator = new PlanExecutor();
		
		var generateTime = Stopwatch.createStarted;
		var out = generator.process(plan, input);
		generateTime.stop;
		info("Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
	
		return out;
	}
	
}