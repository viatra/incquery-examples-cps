package org.eclipse.incquery.examples.cps.generator.impl.operations

import com.google.common.collect.Lists
import java.util.ArrayList
import java.util.HashMap
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation

class ApplicationInstanceAllocationOperation implements IGeneratorOperation<CyberPhysicalSystem, CPSFragment> {
	
	val ArrayList<ApplicationInstance> applicationInstances;
	val HashMap<HostClass, Integer> normalizedRatios;
	private extension CPSModelBuilderUtil modelBuilder;
	protected extension Logger logger = Logger.getLogger("cps.generator.impl.ApplicationInstanceAllocationOperation")
	
	new(ArrayList<ApplicationInstance> applicationInstances, HashMap<HostClass, Integer> normalizedRatios) {
		this.applicationInstances = applicationInstances;
		this.normalizedRatios = normalizedRatios;
		this.modelBuilder = new CPSModelBuilderUtil;
	}
	
	override execute(CPSFragment fragment) {
		
		for(hostClass : normalizedRatios.keySet){
			val allocCount = normalizedRatios.get(hostClass);
			val hostInstances = getHostInstancesOfHostClass(fragment, hostClass);
			val sizeOfHosts = hostInstances.size;
			for(i : 0 ..< allocCount){
				val host = hostInstances.get(i % sizeOfHosts);
				val app = applicationInstances.get(i);
				info('''Allocate «app.id» to «host.id»''')
				app.setAllocatedTo(host);
			}
		}
		
		return true;	
	}
	
	def getHostInstancesOfHostClass(CPSFragment fragment, HostClass hostClass) {
		val hostTypeList = fragment.hostTypes.get(hostClass);
		var hostInstances = Lists.<HostInstance>newArrayList;
		for(hostType : hostTypeList){
			hostInstances.addAll(hostType.instances);		
		}
		return hostInstances;
	}
	
}