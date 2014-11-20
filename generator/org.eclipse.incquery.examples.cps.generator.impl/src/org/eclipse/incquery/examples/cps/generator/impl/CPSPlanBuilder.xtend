package org.eclipse.incquery.examples.cps.generator.impl

import org.eclipse.incquery.examples.cps.generator.impl.dtos.GeneratorPlan
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhaseApplicationAllocation
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhaseHostCommunication
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhaseInstanceGeneration
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhaseSignalSet
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhaseTypeGeneration
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhaseActionGeneration
import org.eclipse.incquery.examples.cps.generator.impl.phases.CPSPhasePrepare

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