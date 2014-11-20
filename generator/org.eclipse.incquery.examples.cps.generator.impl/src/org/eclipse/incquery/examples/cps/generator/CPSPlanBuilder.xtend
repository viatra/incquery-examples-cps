package org.eclipse.incquery.examples.cps.generator

import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorPlan
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseActionGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseApplicationAllocation
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseHostCommunication
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseInstanceGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhasePrepare
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseSignalSet
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseTypeGeneration

class CPSPlanBuilder {
	
	def static buildDefaultPlan(){
		var GeneratorPlan plan = new GeneratorPlan();
		
		plan.addPhase(new CPSPhasePrepare());
		plan.addPhase(new CPSPhaseSignalSet());
		plan.addPhase(new CPSPhaseTypeGeneration());
		plan.addPhase(new CPSPhaseInstanceGeneration());
		plan.addPhase(new CPSPhaseHostCommunication());
		plan.addPhase(new CPSPhaseApplicationAllocation());
		plan.addPhase(new CPSPhaseActionGeneration());
		
		plan;
	}
}