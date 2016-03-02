package org.eclipse.viatra.examples.cps.generator.operations

import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.viatra.examples.cps.generator.dtos.AppClass
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.generator.utils.RandomUtils
import org.eclipse.viatra.examples.cps.planexecutor.api.IOperation
import org.apache.log4j.Logger

class ApplicationInstanceGenerationOperation implements IOperation<CPSFragment> {
	protected extension Logger logger = Logger.getLogger("cps.generator.impl.ApplicationInstanceGenerationOperation")
	
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
		debug("--> AppInstances of " + appType.id + " = " +numberOfAppInstances)
		for(i : 0 ..< numberOfAppInstances){
			appType.prepareApplicationInstanceWithId(appType.id + ".inst" + i);
		}

		true;
	}
	
}