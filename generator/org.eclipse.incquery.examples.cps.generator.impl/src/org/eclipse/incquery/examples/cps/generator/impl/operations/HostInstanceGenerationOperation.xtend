package org.eclipse.incquery.examples.cps.generator.impl.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostType
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class HostInstanceGenerationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
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
			val instance = hostType.prepareHostInstanceWithIP(hostType.id + ".inst"+i, hostType.id + ".inst"+i);
			fragment.addHostInstance(hostClass, instance);
		}

		true;
	}
	
}