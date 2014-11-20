package org.eclipse.incquery.examples.cps.generator.impl.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.impl.utils.RandomUtils
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation

class HostTypeGenerationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
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