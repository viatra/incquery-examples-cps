package org.eclipse.incquery.examples.cps.generator.impl.dtos

import com.google.common.collect.HashMultimap
import com.google.common.collect.Multimap
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostType
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorFragment
import org.eclipse.incquery.examples.cps.generator.dtos.GeneratorInput

class CPSFragment extends GeneratorFragment<CyberPhysicalSystem>{
	
	int numberOfSignals;
	Multimap<HostClass, HostType> hostTypes = HashMultimap.create;
	Multimap<AppClass, ApplicationType> applicationTypes = HashMultimap.create;
	
	new(GeneratorInput<CyberPhysicalSystem> input) {
		super(input)
	}
	
	def getNumberOfSignals(){
		return numberOfSignals;
	}
	
	def setNumberOfSignals(int numberOfSignals){
		this.numberOfSignals = numberOfSignals;
	}
	
	def addHostType(HostClass hostClass, HostType hostType){
		hostTypes.put(hostClass, hostType);
	}
	
	def getHostTypes(){
		return hostTypes;
	}
	
	def getApplicationTypes(){
		return applicationTypes;
	}
	
	def addApplicationType(AppClass appClass, ApplicationType appType){
		applicationTypes.put(appClass, appType);
	}
	
}