package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import java.util.Random
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.tests.constraints.BuildableCPSConstraint
import org.eclipse.incquery.examples.cps.generator.tests.constraints.scenarios.IScenario
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils

class ClientServerScenario implements IScenario {
	
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
		val serverHostTypeCount = 1
		info("-->    Server HostType count = " + serverHostTypeCount);
		val clientHostTypeCount = typCount - serverHostTypeCount
		info("-->    Client HostType count = " + clientHostTypeCount);
		
		
		val instCount = C * 4
		info("--> HostInstance count = " + instCount);
		val serverHostInstanceCount = 1
		info("-->    Server HostInstance count = " + serverHostInstanceCount);
		val clientHostInstanceCount = (instCount-serverHostInstanceCount) / clientHostTypeCount
		info("-->    Client HostInstance count = " + clientHostInstanceCount);
		
		val int comCount = instCount
		info("--> Server Host comm count = " + comCount);
		
		val serverCommRatio = <HostClass, Integer>newHashMap
		val clientCommRatio = <HostClass, Integer>newHashMap
		
		// Client
		var clientTypeMin = clientHostTypeCount
		if(clientTypeMin < 1){
			clientTypeMin = 1
		}
		var clientInstMin = clientHostInstanceCount
		if(clientInstMin < 1){
			clientInstMin = 1
		}
		this.clientHostClass = new HostClass(
			"client", // name
			new MinMaxData<Integer>(clientTypeMin, clientTypeMin), // Type
			new MinMaxData<Integer>(clientInstMin, clientInstMin), //Instance
			new MinMaxData<Integer>(0, 0), //ComLines
			Maps.newHashMap(clientCommRatio)
		)
		
		// Server
		serverCommRatio.put(clientHostClass, 1)
		
		this.serverHostClass = new HostClass(
			"server", // name
			new MinMaxData<Integer>(1, 1), // Type
			new MinMaxData<Integer>(1, 1), //Instance
			new MinMaxData<Integer>(comCount, (comCount*1.5) as int), //ComLines
			Maps.newHashMap(serverCommRatio)
		)
		
		hostClasses.add(serverHostClass)
		hostClasses.add(clientHostClass)
		
		return hostClasses;
	}
	
	private def Iterable<AppClass> createAppClassList() {
		val appClasses = Lists.<AppClass>newArrayList;
		
		val appClassCount = new MinMaxData<Integer>(2, 2).randInt(rand);
		info("--> AppClass count = " + appClassCount);
		
		val appTypeCount = new MinMaxData<Integer>(appClassCount, C + appClassCount).randInt(rand);
		info("--> AppType count = " + appTypeCount);
		val serverAppTypeCount = 1
		info("-->    Server AppClass type = " + serverAppTypeCount);
		val clientAppTypeCount = appTypeCount - serverAppTypeCount
		info("-->    Client AppClass type = " + clientAppTypeCount);
		
		val appInstanceCount = new MinMaxData<Integer>(appClassCount, C + appClassCount).randInt(rand);
		info("--> AppInstanceCount = " + appInstanceCount);
		val serverAppInstanceCount = 1
		info("-->    Server AppClass type = " + serverAppInstanceCount);
		val clientAppInstanceCount = (appInstanceCount - serverAppInstanceCount) / clientAppTypeCount
		info("-->    Client AppClass type = " + clientAppInstanceCount);
		
		
		// Server Apps
		var serverAllocRatios = <HostClass, Integer>newHashMap();
		// alloc ratios
		serverAllocRatios.put(serverHostClass, 1);
		
		val serverAppClass = new AppClass(
			"ServerAppClass",
			new MinMaxData<Integer>(serverAppTypeCount, serverAppTypeCount), // AppTypes
			new MinMaxData<Integer>(serverAppInstanceCount, serverAppInstanceCount), // AppInstances
			new MinMaxData<Integer>(30, 50), // States
			new MinMaxData<Integer>(30, 40), // Transitions
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
			new MinMaxData(clientAppTypeCount, clientAppTypeCount), // AppTypes
			new MinMaxData(clientAppInstanceCount, clientAppInstanceCount), // AppInstances
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
	
}