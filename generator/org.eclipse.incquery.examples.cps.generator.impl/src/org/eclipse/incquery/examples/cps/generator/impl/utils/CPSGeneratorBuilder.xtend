package org.eclipse.incquery.examples.cps.generator.impl.utils

import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.planexecutor.PlanExecutor
import org.eclipse.incquery.examples.cps.planexecutor.generator.GeneratorInput

class CPSGeneratorBuilder {
	
	protected static extension Logger logger = Logger.getLogger("cps.generator.impl.CPSGeneratorBuilder")
	
	def static CPSFragment buildAndGenerateModel(long seed,  ICPSConstraints constraints){
		val CPSModelBuilderUtil mb = new CPSModelBuilderUtil;
		val cps2dep = mb.prepareEmptyModel("testModel"+System.nanoTime);
		
		if(cps2dep != null && cps2dep.cps != null){
			return buildAndGenerateModel(seed, constraints, cps2dep.cps);
		}else{
			info("!!! Error: Cannot create CPS model");
			return new CPSFragment(new GeneratorInput(seed, constraints, null));
		}
	}
	
	def static buildAndGenerateModel(long seed,  ICPSConstraints constraints, CyberPhysicalSystem model){
		val GeneratorInput<CyberPhysicalSystem> input = new GeneratorInput(seed, constraints, model);
		var plan = CPSPlanBuilder.buildDefaultPlan;
		
		var PlanExecutor<CPSFragment, GeneratorInput<CyberPhysicalSystem>> generator = new PlanExecutor();
		
		var generateTime = Stopwatch.createStarted;
		var out = generator.generate(plan, input);
		generateTime.stop;
		info("Generating time: " + generateTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
	
		return out;
	}
	
}