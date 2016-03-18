package org.eclipse.incquery.examples.cps.generator.utils

import java.util.Collection
import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.generator.dtos.CPSStats
import org.eclipse.incquery.examples.cps.generator.dtos.DeploymentStats
import org.eclipse.incquery.examples.cps.generator.dtos.TraceabilityStats
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.exception.IncQueryException

class StatsUtil {
	
	def static generateStatsForCPS(IncQueryEngine engine, CyberPhysicalSystem model){
		return new CPSStats(engine, model);
	}
	
	def static generateStatsForDeployment(IncQueryEngine engine, Deployment model){
		return new DeploymentStats(engine, model);
	}
	
	def static generateStatsForTraceability(IncQueryEngine engine, CPSToDeployment model){
		return new TraceabilityStats(engine, model);
	}
	
	def static size(EObject eobject){
		 eobject?.eAllContents.size
	}
	
	def static int countEdges(EObject model) throws IncQueryException {
		val Collection<EObject> eObjects = model.eAllContents.toList

		var int countTriples = 0;
		for (EObject eObject : eObjects) {
			for(feature : eObject.eClass.EAllReferences){
				val value = eObject.eGet(feature);
				if (feature.isMany()) {
					countTriples += (value as Collection).size
				} else {
					if (value!= null) {
						countTriples++;
					}
				}
			}
		}
		return countTriples;
	}
}