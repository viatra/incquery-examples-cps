package org.eclipse.incquery.examples.cps.generator.dtos

import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.utils.SumProcessor
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.traceability.TraceabilityPackage
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.query.runtime.base.api.IncQueryBaseFactory
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil

class TraceabilityStats extends ModelStats {
	
	private Logger logger = Logger.getLogger("cps.generator.StatsUtil.TraceabilityStats")
	
	public int traceabilityCPSDepTrace = 0;
	public int traceabilityCPSDepTraceCPSElements = 0;
	public int traceabilityDeploymentElements = 0;
	
	def log() {
		logger.info("====================================================================")
		logger.info("= Traceability Stats: ");
		logger.info("=   CPSDepTrace: " + traceabilityCPSDepTrace);
		logger.info("=   CPSElements: " + traceabilityCPSDepTraceCPSElements);
		logger.info("=   DeploymentElements: " + traceabilityDeploymentElements);
		logger.info("=   EObjects: " + eObjects);
		logger.info("=   EReferences: " + eReferences);
		logger.info("====================================================================")
	}
	
	new(ViatraQueryEngine engine, CPSToDeployment model){
		val baseIndex = IncQueryBaseFactory.getInstance.createNavigationHelper(model.eResource.resourceSet, true, logger)
		// TODO one SumProcessor
		
		// EClasses
		val sumProcessor = new SumProcessor
		baseIndex.processAllInstances(TraceabilityPackage.Literals.CPS2_DEPLYOMENT_TRACE, sumProcessor)	
		this.traceabilityCPSDepTrace = sumProcessor.sum
		sumProcessor.resetSum
		
		
		// EFeatures
		val sp2 = new SumProcessor
		baseIndex.processAllFeatureInstances(TraceabilityPackage.Literals.CPS2_DEPLYOMENT_TRACE__CPS_ELEMENTS, sp2)	
		this.traceabilityCPSDepTraceCPSElements = sp2.sum
		sp2.resetSum
		
		val sp3 = new SumProcessor
		baseIndex.processAllFeatureInstances(TraceabilityPackage.Literals.CPS2_DEPLYOMENT_TRACE__DEPLOYMENT_ELEMENTS, sp3)	
		this.traceabilityDeploymentElements = sp3.sum
		sp3.resetSum
		
		this.eObjects = model.eAllContents.size
		this.eReferences = StatsUtil.countEdges(model)
	}
}