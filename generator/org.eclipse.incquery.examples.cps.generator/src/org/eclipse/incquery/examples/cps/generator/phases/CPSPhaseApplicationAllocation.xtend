package org.eclipse.incquery.examples.cps.generator.phases

import com.google.common.collect.Lists
import java.util.HashMap
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.operations.ApplicationInstanceAllocationOperation
import org.eclipse.incquery.examples.cps.generator.utils.MapUtil
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IPhase

class CPSPhaseApplicationAllocation implements IPhase<CPSFragment>{
	
	private extension RandomUtils randUtil = new RandomUtils;
	protected extension Logger logger = Logger.getLogger("cps.generator.impl.CPSPhaseApplicationAllocation")
	
	override getOperations(CPSFragment fragment) {
		val operations = Lists.newArrayList();
		
		// Add operations for Allocate applicationInstances to HostInstances
		for(appClass : fragment.applicationTypes.keySet){
			val apps = collectApplicationInstancesForAllocationByAppClass(appClass, fragment);
			if(!apps.empty){
				var sumRatio = calculateSumRatio(appClass);
				if(sumRatio != 0){
					val allocationRatios = new HashMap<HostClass, Double>();
					for(hostClass : appClass.allocationRatios.keySet){
						var numberOfAllocatedApps = ((appClass.allocationRatios.get(hostClass) as double) / (sumRatio as double)) * apps.size;				
						allocationRatios.put(hostClass, numberOfAllocatedApps);
					}
					val normRatios = normalizeRatios(allocationRatios, sumRatio, apps.size);
					operations.add(new ApplicationInstanceAllocationOperation(apps, normRatios));
				}else{
					debug("#Warning#: Ratio is empty");
				}
			}else{
				debug("#Warning#: ApplicationInstancesForAllocation is empty");
			}
			
		}
		
		return operations;
	}
	
	def normalizeRatios(HashMap<HostClass, Double> ratios, int sumRatio, int appsSize) {
		var HashMap<HostClass, Integer> normalizedRatios = new HashMap;
		// Floor allocation count
		var sumAllocCount = 0;
		for(hostClass : ratios.keySet){
			val allocCount = Math.floor(ratios.get(hostClass)) as int
			normalizedRatios.put(hostClass, allocCount);
			sumAllocCount += allocCount;
		}
		
		// Partition remainders
		debug("SumApp: " + appsSize + ", FlooredAlloc: " + sumAllocCount);
		if(sumAllocCount < appsSize){
			for(hostClass : ratios.keySet){
				var value = ratios.get(hostClass);
				var fraction = value - ((value as double) as long);
				ratios.put(hostClass, fraction);
			}
			
			var remainder = appsSize - sumAllocCount;
			val sortedMapEntires = MapUtil.entriesSortedByValues(ratios);
			
			if(remainder > normalizedRatios.size){
				debug("#Warning#: The remainder is greater than the size of targets.")	
			}
			
			for(index : 0 ..< remainder){
				val actualValue = normalizedRatios.get(sortedMapEntires.get(index).key);
				normalizedRatios.put(sortedMapEntires.get(index).key, actualValue + 1);
			}
		}
		
		return normalizedRatios;
	}
	
	def calculateSumRatio(AppClass appClass) {
		var sumRatio = 0;
		for(hostClass : appClass.allocationRatios.keySet){
			sumRatio += appClass.allocationRatios.get(hostClass);
		}
		return sumRatio;
	}
	
	def collectApplicationInstancesForAllocationByAppClass(AppClass appClass, CPSFragment fragment) {
		val appTypes = fragment.applicationTypes.get(appClass);
		val appsForAllocateByAppClass = Lists.newArrayList;
		for(appType : appTypes){
			appsForAllocateByAppClass.addAll(collectApplicationsForAllocation(appType, appClass, fragment));
		}
		return appsForAllocateByAppClass;
	}
	
	def collectApplicationsForAllocation(ApplicationType appType, AppClass appClass, CPSFragment fragment) {
		var numberOfAllocations = Math.round(Percentage.value(appType.instances.size, appClass.percentOfAllocatedInstances)) as int;
		var appsForAllocate = Lists.<ApplicationInstance>newArrayList;
		for(i : 0 ..< numberOfAllocations){
			appsForAllocate.add(appType.instances.randElementExcept(appsForAllocate, fragment.random));
		}
		return appsForAllocate;
	}
	
}