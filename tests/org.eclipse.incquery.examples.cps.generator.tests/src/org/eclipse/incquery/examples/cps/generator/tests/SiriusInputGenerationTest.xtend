package org.eclipse.incquery.examples.cps.generator.tests

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Random
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.generator.dtos.AppClass
import org.eclipse.incquery.examples.cps.generator.dtos.BuildableCPSConstraint
import org.eclipse.incquery.examples.cps.generator.dtos.HostClass
import org.eclipse.incquery.examples.cps.generator.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.dtos.Percentage
import org.eclipse.incquery.examples.cps.generator.utils.PersistenceUtil
import org.junit.Test
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.CPSPlans
import org.junit.Ignore

class SiriusInputGenerationTest extends TestBase {
	
	public int scale
	public Random rand
	protected extension Logger logger = Logger.getLogger("cps.generator.tests.SiriusInputGenerationTest")
	
	Iterable<HostClass> hostClasses = ImmutableList.of();
	
	@Ignore
	@Test
	def basicScenario1(){
		scale = 1
		runBasicScenario()
	}
	
	@Ignore
	@Test
	def basicScenario2(){
		scale = 2
		runBasicScenario()
	}
		
	@Ignore
	@Test
	def basicScenario4(){
		scale = 4
		runBasicScenario()
	}
		
//	@Ignore
	@Test
	def basicScenario8(){
		scale = 8
		runBasicScenario()
	}
		
	@Ignore
	@Test
	def basicScenario16(){
		scale = 16
		runBasicScenario()
	}
	
	@Ignore
	@Test
	def basicScenario32(){
		scale = 32
		runBasicScenario()
	}
	
	@Ignore
	@Test
	def basicScenario64(){
		scale = 64
		runBasicScenario()
	}
	
	@Ignore
	@Test
	def basicScenario128(){
		scale = 128
		runBasicScenario()
	}
	
	@Ignore
	@Test
	def basicScenario256(){
		scale = 256
		runBasicScenario()
	}
	
	def runBasicScenario(){
		Logger.getLogger("cps.generator").level = Level.INFO
		val seed = 11111
		rand = new Random(seed)
		val out = CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints, CPSPlans.SIMPLE_ACTION);		
		
		val filePath = '''./output/«System.currentTimeMillis/1000000»/stat-«scale».cyberphysicalsystem''';
		PersistenceUtil.saveCPSModelToFile(out.modelRoot, filePath);
		
		return
	}
	
	def getConstraints() {
		info("--> Scale = " + scale);

		this.hostClasses = createHostClassList()

		val signalCount = scale * 10
		val BuildableCPSConstraint cons = new BuildableCPSConstraint(
			"Statistics-based Case",
			new MinMaxData<Integer>(signalCount, signalCount), // Sig
			createAppClassList(),
			this.hostClasses
		);

		return cons;
	}
	
	private def Iterable<HostClass> createHostClassList() {
		val hostClasses = Lists.<HostClass>newArrayList;
		
		// 1 for the empty, and scale for the host instances with allocated application instances
		val hostClassCount = 1 + scale;
		info("--> HostClass count = " + hostClassCount);

		val typCount = hostClassCount;
		info("--> HostType count = " + typCount);

		val instEmptyCount = scale * 3;
		val instAppContainerCount = Math.max(1, Math.sqrt(scale).intValue);
		val instHostCount = instEmptyCount + instAppContainerCount
		info("--> HostInstance count = " + instHostCount)
		val comCount = instAppContainerCount - 1;

		// TODO should we randomize the number of host communication for the hosts without allocated applications
		val emptyHostCommunicationCount = scale * 2
		val allComCount = comCount + emptyHostCommunicationCount
		info("--> Host comm count = " + allComCount)
		
		
		val emptyHostConnection = new HashMap
		val emptyHostClass = new HostClass(
			"HC_empty", // name
			new MinMaxData(1, 1), // Type
			new MinMaxData(instEmptyCount, instEmptyCount), //Instance
			new MinMaxData(emptyHostCommunicationCount, emptyHostCommunicationCount), //ComLines
			emptyHostConnection
		)
		hostClasses.add(emptyHostClass)

		val appContainerClasses = Lists.newArrayList
		for (i : 0 ..< scale) {

			// The application container host instances of the same type will form a complete graph of 4
			// when only taking the communicatesWith relation
			val appContainerConnection = new HashMap
			val appContainerHostClass = new HostClass(
				"HC_appContainer" + i, // name
				new MinMaxData(1, 1), // Type
				new MinMaxData(instAppContainerCount, instAppContainerCount), //Instance
				new MinMaxData(comCount, comCount), //ComLines
				appContainerConnection
			)
			appContainerConnection.put(appContainerHostClass, 1)

			hostClasses.add(appContainerHostClass)
			appContainerClasses.add(appContainerHostClass)
		}

		// Communications:
		// App containers only communicate with each other, the empty hosts might communicate with any instance		
		emptyHostConnection.put(emptyHostClass, 1)
		for (appContainerClass : appContainerClasses) {
			emptyHostConnection.put(appContainerClass, 1)
		}

		return hostClasses;
	}

	private def Iterable<AppClass> createAppClassList() {
		val appClasses = Lists.<AppClass>newArrayList;

		val int appClassCount = Math.max(1, Math.sqrt(scale).intValue);
		
		info("--> AppClass count = " + appClassCount);

		// alloc ratios - allocate only to the second host type
		var Map<HostClass, Integer> allocRatios = new HashMap();
		val hostClassesList = this.hostClasses as List<HostClass>
		val emptyHostClass = hostClassesList.get(0)

		// The first in the list is the empty host class, the instances of the others should contain app instances
		for (hostClass : this.hostClasses) {
			if (hostClass.equals(emptyHostClass)) {
				allocRatios.put(hostClass, 0);
			} else {
				allocRatios.put(hostClass, 1);
			}
		}

		
		val appTypeMinCount = 1
		val appTypeMaxCount = 2

		val appInstCount = Math.max(2, scale)
		info("--> AppInstance count = " + appInstCount);

		for(i : 0 ..< appClassCount){			
			appClasses.add(
				new AppClass(
					"AC_withStateMachine" + i,
					new MinMaxData(appTypeMinCount, appTypeMaxCount), // AppTypes
					new MinMaxData(appInstCount, appInstCount), // AppInstances
					new MinMaxData(50, 100), // States
					new MinMaxData(100, 100), // Transitions
					new Percentage(30), // Alloc 
					allocRatios,
					new Percentage(2), // Action
					new Percentage(10) // Send
				)
			);
		}

		return appClasses;
	}
}