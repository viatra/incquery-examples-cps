package org.eclipse.incquery.examples.cps.generator

import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorPlan
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseActionGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseActionStatisticsBasedGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseApplicationAllocation
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseHostCommunication
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseInstanceGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhasePrepare
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseSignalSet
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseTypeGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseTypeStatisticsBasedGeneration
import org.eclipse.incquery.examples.cps.generator.phases.CPSPhaseActionSimpleGeneration

enum CPSPlans{
	DEFAULT, STATISTICS_BASED, SIMPLE_ACTION
}

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

	def static buildCharacteristicBasedPlan(){
		var GeneratorPlan plan = new GeneratorPlan();
		
		plan.addPhase(new CPSPhasePrepare());
		plan.addPhase(new CPSPhaseSignalSet());
		plan.addPhase(new CPSPhaseTypeStatisticsBasedGeneration());
		plan.addPhase(new CPSPhaseInstanceGeneration());
		plan.addPhase(new CPSPhaseHostCommunication());
		plan.addPhase(new CPSPhaseApplicationAllocation());
		plan.addPhase(new CPSPhaseActionStatisticsBasedGeneration());
		
		plan;
	}
	
	def static buildCharacteristicBasedSimplePlan(){
		var GeneratorPlan plan = new GeneratorPlan();
		
		plan.addPhase(new CPSPhasePrepare());
		plan.addPhase(new CPSPhaseSignalSet());
		plan.addPhase(new CPSPhaseTypeStatisticsBasedGeneration());
		plan.addPhase(new CPSPhaseInstanceGeneration());
		plan.addPhase(new CPSPhaseHostCommunication());
		plan.addPhase(new CPSPhaseApplicationAllocation());
		plan.addPhase(new CPSPhaseActionSimpleGeneration());
		
		plan;
	}
}