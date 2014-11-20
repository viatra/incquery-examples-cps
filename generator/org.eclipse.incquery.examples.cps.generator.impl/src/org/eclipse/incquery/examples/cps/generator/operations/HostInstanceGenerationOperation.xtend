package org.eclipse.incquery.examples.cps.generator.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostType
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IOperation

class HostInstanceGenerationOperation implements IOperation<CPSFragment> {
	val HostClass hostClass;
	val HostType hostType;
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	new(HostClass hostClass, HostType type){
		this.hostClass = hostClass;
		this.hostType = type;
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		// Generate Host Instances
		val numberOfHostInstances = hostClass.numberOfHostInstances.randInt(fragment.random);

		for(i : 0 ..< numberOfHostInstances){
			// TODO generate valid IP addresses 
			hostType.prepareHostInstanceWithIP(hostType.id + ".inst"+i, hostType.id + ".inst"+i);
		}

		true;
	}
	
}