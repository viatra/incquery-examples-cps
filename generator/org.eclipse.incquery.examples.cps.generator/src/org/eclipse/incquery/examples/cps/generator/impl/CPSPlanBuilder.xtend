package org.eclipse.incquery.examples.cps.generator.impl

import org.eclipse.incquery.examples.cps.generator.GeneratorPlan

class CPSPlanBuilder {
	
	def static build(){
		var GeneratorPlan plan = new GeneratorPlan();
		plan.addPhase(new CPSPhaseSignalSet());
		plan.addPhase(new CPSPhaseTypeGeneration());
		plan.addPhase(new CPSPhaseInstanceGeneration());
		plan.addPhase(new CPSPhaseHostCommunication());
		
		plan;
	}
}