package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import java.util.Random
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.BuildableCPSConstraint
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import eu.mondo.sam.core.scenarios.BenchmarkScenario
import eu.mondo.sam.core.results.CaseDescriptor
import eu.mondo.sam.core.phases.SequencePhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.TransformationPhase
import eu.mondo.sam.core.phases.IterationPhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.GenerationPhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.InitializationPhase

class AdvancedClientServerScenario extends BenchmarkScenario implements IScenario {
	
	protected extension Logger logger = Logger.getLogger("cps.xform.LowSynchScenario")
	protected extension RandomUtils randUtil = new RandomUtils;
	
	Random rand;
	int C;
	
	double Ssig = 0.1; // Scattering of Signals
	
	Iterable<HostClass> hostClasses = ImmutableList.of();
	HostClass serverHostClass
	HostClass clientHostClass
	
	new(Random rand){
		this.rand = rand;
	}
	
	override getConstraintsFor(int countOfElements) {
		C = Math.ceil(Math.sqrt(countOfElements*1000)) as int; // xxx
		
		info("--> Element count = " + countOfElements);
		info("--> C = " + C);
		
		this.hostClasses = createHostClassList()
		
		val min = Math.ceil(C*(5-Ssig)) as int;
		val max = Math.ceil(C*(5+Ssig)) as int;
		
		info('''--> Signal min: «min», max: «max»''');
		val BuildableCPSConstraint cons = new BuildableCPSConstraint(
			"Client-Server Scenario",
			new MinMaxData<Integer>(min, max), // Signals
			createAppClassList(),
			this.hostClasses	
		);
		
		return cons;
	}
	
	def Iterable<HostClass> createHostClassList() {
		val hostClasses = Lists.<HostClass>newArrayList;
		
		val hostClassCount = new MinMaxData<Integer>(2, 2).randInt(rand);
		info("--> HostClass count = " + hostClassCount);
		
		val typCount = 1 + C/2;
		info("--> HostType count = " + typCount);
		val serverHostTypeCount = (typCount*0.2) as int
		info("-->    Server HostType count = " + serverHostTypeCount);
		val clientHostTypeCount = (typCount*0.8) as int
		info("-->    Client HostType count = " + clientHostTypeCount);
		
		
		val instCount = C * 4
		info("--> HostInstance count = " + instCount);
		val serverHostInstanceCount = (instCount*0.3 / serverHostTypeCount) as int
		info("-->    Server HostInstance count = " + serverHostInstanceCount);
		val clientHostInstanceCount = (instCount*0.7 / clientHostTypeCount) as int
		info("-->    Client HostInstance count = " + clientHostInstanceCount);
		
		val int comCount = (instCount*0.7 / typCount*0.82) as int;
		info("--> Server Host comm count = " + comCount);
		
		val serverCommRatio = <HostClass, Integer>newHashMap
		val clientCommRatio = <HostClass, Integer>newHashMap

		var serverTypeMin = serverHostTypeCount
		if(serverTypeMin < 1){
			serverTypeMin = 1
		}
		var serverInstMin = serverHostInstanceCount
		if(serverInstMin < 1){
			serverInstMin = 1
		}
		this.serverHostClass = new HostClass(
			"server", // name
			new MinMaxData<Integer>(serverTypeMin, serverTypeMin), // Type
			new MinMaxData<Integer>(serverInstMin, serverInstMin), //Instance
			new MinMaxData<Integer>(comCount/2, comCount), //ComLines
			Maps.newHashMap(serverCommRatio)
		)
		
		
		var clientTypeMin = clientHostTypeCount
		if(serverTypeMin < 1){
			serverTypeMin = 1
		}
		var clientInstMin = clientHostInstanceCount
		if(serverInstMin < 1){
			serverInstMin = 1
		}
		this.clientHostClass = new HostClass(
			"client", // name
			new MinMaxData<Integer>(clientTypeMin, clientTypeMin), // Type
			new MinMaxData<Integer>(clientInstMin, clientInstMin), //Instance
			new MinMaxData<Integer>(0, 0), //ComLines
			Maps.newHashMap(clientCommRatio)
		)
		
		serverCommRatio.put(clientHostClass, 1)
		hostClasses.add(serverHostClass)
		hostClasses.add(clientHostClass)
		
		return hostClasses;
	}
	
	private def Iterable<AppClass> createAppClassList() {
		val appClasses = Lists.<AppClass>newArrayList;
		
		val appClassCount = new MinMaxData<Integer>(2, 2).randInt(rand);
		info("--> AppClass count = " + appClassCount);
		
		val appTypeCount = new MinMaxData<Integer>(appClassCount, C + appClassCount).randInt(rand);
		info("--> AppClass type = " + appTypeCount);
		info("-->    Server AppClass type = " + (appTypeCount * 0.3) as int);
		info("-->    Client AppClass type = " + (appTypeCount * 0.7) as int);
		
		val appInstanceCount = new MinMaxData<Integer>(appClassCount, C + appClassCount).randInt(rand);
		info("--> appInstanceCount = " + appInstanceCount);
		info("-->    Server AppClass type = " + (appInstanceCount * 0.25) as int);
		info("-->    Client AppClass type = " + (appInstanceCount * 0.75) as int);
		
		
		// Server Apps
		var serverAllocRatios = <HostClass, Integer>newHashMap();
		// alloc ratios
		serverAllocRatios.put(serverHostClass, 1);
		
		val serverAppClass = new AppClass(
			"ServerAppClass",
			new MinMaxData<Integer>((appTypeCount * 0.3) as int, (appTypeCount * 0.3) as int), // AppTypes
			new MinMaxData<Integer>((appInstanceCount * 0.22) as int, (appInstanceCount * 0.27) as int), // AppInstances
			new MinMaxData<Integer>(C, C), // States
			new MinMaxData<Integer>(C/2, C/2), // Transitions
			new Percentage(100), // AllocInst
			serverAllocRatios,
			new Percentage(30), // Action %
			new Percentage(100) // Send %
		)
		appClasses += serverAppClass
		
		
		// Client
		var clientAllocRatios = <HostClass, Integer>newHashMap();
		// alloc ratios
		clientAllocRatios.put(clientHostClass, 1)
		
		val clientAppClass = new AppClass(
			"ClientAppClass",
			new MinMaxData((appTypeCount * 0.7) as int, (appTypeCount * 0.7) as int), // AppTypes
			new MinMaxData((appInstanceCount * 0.72) as int, (appInstanceCount * 0.77) as int), // AppInstances
			new MinMaxData(5, 10), // States
			new MinMaxData(3, 8), // Transitions
			new Percentage(100), // AllocInst
			clientAllocRatios,
			new Percentage(5), // Action %
			new Percentage(0) // Send %
		)
		appClasses += clientAppClass
		
		return appClasses;
	}
	
	override build() {
		val seq = new SequencePhase
		seq.addPhases(
			new GenerationPhase("Generation"),
			new InitializationPhase("Initialization"),
			new TransformationPhase("Transformation")
		)
		rootPhase = seq
	}
	
	override getCaseDescriptor() {
		val descriptor = new CaseDescriptor
		descriptor.tool = tool
		descriptor.caseName = caseName
		descriptor.size = size
		descriptor.runIndex = runIndex
		descriptor.scenario = "AdvancedClientServer"
		
		return descriptor
	}
	
}