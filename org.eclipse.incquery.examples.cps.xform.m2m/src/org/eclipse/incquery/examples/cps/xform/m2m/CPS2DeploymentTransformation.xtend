package org.eclipse.incquery.examples.cps.xform.m2m

import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import static com.google.common.base.Preconditions.*
import org.apache.log4j.Logger
import org.apache.log4j.Level

class CPS2DeploymentTransformation {
	
	Logger logger = Logger.getLogger(typeof(CPS2DeploymentTransformation))
	
	new(){
		logger.setLevel(Level.INFO)
	}
	
	def execute(CPSToDeployment mapping) {
		
		checkState(mapping.cps != null, "CPS not defined in mapping!")
		checkState(mapping.deployment != null, "Deployment not defined in mapping!")
		
		logger.info('''
			Executing transformation on:
				Cyber-physical system: «mapping.cps.id»''')
		
	}
	
}