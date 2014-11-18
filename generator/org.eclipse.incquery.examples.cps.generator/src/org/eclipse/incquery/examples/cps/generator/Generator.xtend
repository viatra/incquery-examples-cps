package org.eclipse.incquery.examples.cps.generator

import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment
import org.apache.log4j.Logger

class Generator {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Generator")
	
	def generate(GeneratorInput input){
		var GeneratorFragment output = new GeneratorFragment(input); 
		output.phaseSignalSet.phaseTypeGeneration.phaseInstanceGeneration;
	}
	
	private def phaseSignalSet(GeneratorFragment fragment){
		info("Phase Signal Set generation is started.");
		
		info("Phase Signal Set generation is done.");
		return fragment;
	}
	
	private def phaseTypeGeneration(GeneratorFragment fragment){
		info("Phase Type generation is started.");
		
		info("Phase Type generation is done.");
		return fragment;
	}
	
	private def phaseInstanceGeneration(GeneratorFragment fragment){
		info("Phase Instances generation is started.");
		
		info("Phase Instances generation is done.");
		return fragment;
	}
	
}