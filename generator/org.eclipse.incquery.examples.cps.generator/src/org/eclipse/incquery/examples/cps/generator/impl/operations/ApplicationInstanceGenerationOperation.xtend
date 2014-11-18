package org.eclipse.incquery.examples.cps.generator.impl.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class ApplicationInstanceGenerationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
	val AppClass applicationClass;
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	new(AppClass applicationClass){
		this.applicationClass = applicationClass;
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		// Generate ApplicationTypes
		val numberOfAppInstances = applicationClass.numberOfAppInstances.randInt(fragment.random);

		true;
	}
	
}