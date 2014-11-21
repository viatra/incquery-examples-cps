package org.eclipse.incquery.examples.cps.generator.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.planexecutor.api.IOperation

class ApplicationInstanceGenerationOperation implements IOperation<CPSFragment> {
	val AppClass applicationClass;
	val ApplicationType appType;
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	new(AppClass applicationClass, ApplicationType appType){
		this.applicationClass = applicationClass;
		this.appType = appType;
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		// Generate ApplicationInstances
		val numberOfAppInstances = applicationClass.numberOfAppInstances.randInt(fragment.random);

		for(i : 0 ..< numberOfAppInstances){
			appType.prepareApplicationInstanceWithId(appType.id + ".inst" + i);
		}

		true;
	}
	
}