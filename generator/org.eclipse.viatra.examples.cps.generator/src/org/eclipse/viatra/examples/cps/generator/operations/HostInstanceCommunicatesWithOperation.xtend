package org.eclipse.viatra.examples.cps.generator.operations

import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil
import org.eclipse.viatra.examples.cps.generator.utils.RandomUtils
import org.eclipse.viatra.examples.cps.planexecutor.api.IOperation

class HostInstanceCommunicatesWithOperation implements IOperation<CPSFragment> {
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