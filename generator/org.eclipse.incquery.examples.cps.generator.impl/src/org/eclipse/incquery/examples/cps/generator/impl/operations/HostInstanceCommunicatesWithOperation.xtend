package org.eclipse.incquery.examples.cps.generator.impl.operations

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class HostInstanceCommunicatesWithOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
	val HostInstance sourceHost;
	val HostInstance targetHost;
	
	private extension CPSModelBuilderUtil modelBuilder;
	private extension RandomUtils randUtil
	
	new(HostInstance sourceHost, HostInstance targetHost){
		this.sourceHost = sourceHost;
		this.targetHost = targetHost;
		modelBuilder = new CPSModelBuilderUtil;
		randUtil = new RandomUtils;
	}
	
	override execute(CPSFragment fragment) {
		// Generate Connection between instances
		sourceHost.prepareCommunication(targetHost);

		true;
	}
	
}