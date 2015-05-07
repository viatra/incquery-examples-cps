package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import eu.mondo.sam.core.phases.IterationPhase
import eu.mondo.sam.core.phases.SequencePhase
import eu.mondo.sam.core.results.CaseDescriptor
import eu.mondo.sam.core.scenarios.BenchmarkScenario
import java.util.Random
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.BuildableCPSConstraint
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.dtos.scenario.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.performance.tests.phases.ClientServerModificationPhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.GenerationPhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.InitializationPhase
import org.eclipse.incquery.examples.cps.performance.tests.phases.M2MTransformationPhase

class ClientServerScenario extends BenchmarkScenario implements IScenario {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.ClientServerScenario")
	protected extension RandomUtils randUtil = new RandomUtils;
	
	Random rand;
	
	Iterable<HostClass> hostClasses = ImmutableList.of();
	HostClass serverHostClass
	HostClass clientHostClass
	
	
	new(Random rand){
		this.rand = rand;
	}
	
	override getConstraintsFor(int scale) {
		info("--> Scale = " + scale);
		
		this.hostClasses = createHostClassList(scale)

		val BuildableCPSConstraint cons = new BuildableCPSConstraint(
			"Client-Server Scenario",
			new MinMaxData<Integer>(1, 1), // Signals
			createAppClassList(scale),
			this.hostClasses	
		);
		
		return cons;
	}
	
	def Iterable<HostClass> createHostClassList(int scale) {
		val hostClasses = Lists.<HostClass>newArrayList;
		
		val hostClassCount = new MinMaxData<Integer>(2, 2).randInt(rand);
		info("--> HostClass count = " + hostClassCount);
		
//		val typCount = 2;
//		info("--> HostType count = " + typCount);
		val serverHostTypeCount = 1
		info("-->    Server HostType count = " + serverHostTypeCount);
		val clientHostTypeCount = 1 //typCount - serverHostTypeCount
		info("-->    Client HostType count = " + clientHostTypeCount);
		
		
//		val instCount = C * 4
//		info("--> HostInstance count = " + instCount);
		val serverHostInstanceCount = 1
		info("-->    Server HostInstance count = " + serverHostInstanceCount);
		val clientHostInstanceCount = 10 * Math.sqrt(scale) as int // (instCount-serverHostInstanceCount) / clientHostTypeCount
		info("-->    Client HostInstance count = " + clientHostInstanceCount);
		
		val int comCount = clientHostInstanceCount //instCount
		info("--> Server Host comm count = " + comCount);
		
		val serverCommRatio = <HostClass, Integer>newHashMap
		val clientCommRatio = <HostClass, Integer>newHashMap
		
		
		this.serverHostClass = new HostClass(
			"server", // name
			new MinMaxData<Integer>(serverHostTypeCount, serverHostTypeCount), // Type
			new MinMaxData<Integer>(serverHostInstanceCount, serverHostInstanceCount), //Instance
			new MinMaxData<Integer>(0, 0), //ComLines
			serverCommRatio
		)
		
		// Client
		var clientTypeMin = clientHostTypeCount
		if(clientTypeMin < 1){
			clientTypeMin = 1
		}
		var clientInstMin = clientHostInstanceCount
		if(clientInstMin < 1){
			clientInstMin = 1
		}
		clientCommRatio.put(serverHostClass, 1)
		this.clientHostClass = new HostClass(
			"client", // name
			new MinMaxData<Integer>(clientTypeMin, clientTypeMin), // Type
			new MinMaxData<Integer>(clientInstMin, clientInstMin), //Instance
			new MinMaxData<Integer>(comCount, comCount), //ComLines
			clientCommRatio
		)
		
		// Server
		
		hostClasses.add(serverHostClass)
		hostClasses.add(clientHostClass)
		
		return hostClasses;
	}
	
	private def Iterable<AppClass> createAppClassList(int scale) {
		val appClasses = Lists.<AppClass>newArrayList;
		
		val appClassCount = new MinMaxData<Integer>(2, 2).randInt(rand);
		info("--> AppClass count = " + appClassCount);
		
		val serverAppTypeCount = 1
		info("-->    Server AppType = " + serverAppTypeCount);
		val clientAppTypeCount = 10 * scale 
		info("-->    Client AppType = " + clientAppTypeCount);

		val serverAppInstanceCount = 1
		info("-->    Server AppInstance = " + serverAppInstanceCount);
		val clientAppInstanceCount = 1
		info("-->    Client AppInstance = " + clientAppInstanceCount);
		
		
		// Server Apps
		var serverAllocRatios = <HostClass, Integer>newHashMap();
		// alloc ratios
		serverAllocRatios.put(serverHostClass, 1);
		
		val serverAppClass = new AppClass(
			"ServerAppClass",
			new MinMaxData<Integer>(serverAppTypeCount, serverAppTypeCount), // AppTypes
			new MinMaxData<Integer>(serverAppInstanceCount, serverAppInstanceCount), // AppInstances
			new MinMaxData<Integer>(30, 30), // States
			new MinMaxData<Integer>(40, 40), // Transitions
			new Percentage(100), // AllocInst
			serverAllocRatios,
			new Percentage(30), // Action %
			new Percentage(0) // Send %
		)
		appClasses += serverAppClass
		
		
		// Client
		var clientAllocRatios = <HostClass, Integer>newHashMap();
		// alloc ratios
		clientAllocRatios.put(clientHostClass, 1)
		
		val clientAppClass = new AppClass(
			"ClientAppClass",
			new MinMaxData(clientAppTypeCount, clientAppTypeCount), // AppTypes
			new MinMaxData(clientAppInstanceCount, clientAppInstanceCount), // AppInstances
			new MinMaxData(3, 3), // States
			new MinMaxData(5, 5), // Transitions
			new Percentage(100), // AllocInst
			clientAllocRatios,
			new Percentage(30), // Action %
			new Percentage(100) // Send %
		)
		appClasses += clientAppClass
		
		return appClasses;
	}
	
	override build() {
		val seq = new SequencePhase
		val innerSeq = new SequencePhase
		innerSeq.addPhases(
			new ClientServerModificationPhase("Modification"), 
			new M2MTransformationPhase("Transformation")
		)
		
		val iter = new IterationPhase(2)
		iter.phase = innerSeq
		
		seq.addPhases(
			new GenerationPhase("Generation"),
			new InitializationPhase("Initialization"),
			new M2MTransformationPhase("Transformation"),
			iter
		)
		rootPhase = seq
	}
	
	override getCaseDescriptor() {
		val descriptor = new CaseDescriptor
		descriptor.tool = tool
		descriptor.caseName = caseName
		descriptor.size = size
		descriptor.runIndex = runIndex
		descriptor.scenario = "ClientServer"
		
		return descriptor
	}
	
}