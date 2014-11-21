package org.eclipse.incquery.examples.cps.generator.operations

import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IOperation

class HostTypeGenerationOperation implements IOperation<CPSFragment> {
	val HostClass hostClass;
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	
	new(HostClass applicationClass){
		this.hostClass = applicationClass;
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		// Generate ApplicationTypes
		val numberOfHostTypes = hostClass.numberOfHostTypes.randInt(fragment.random);
		
		for(i : 0 ..< numberOfHostTypes){
			val hostTypeId = "simple.cps.host." + hostClass.name + i;
			val hostType = fragment.modelRoot.prepareHostTypeWithId(hostTypeId);
			fragment.addHostType(hostClass, hostType);
		}

		true;
	}
	
}