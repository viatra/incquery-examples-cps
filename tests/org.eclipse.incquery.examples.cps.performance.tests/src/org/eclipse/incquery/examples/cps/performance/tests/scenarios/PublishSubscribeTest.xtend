package org.eclipse.incquery.examples.cps.performance.tests.scenarios

import com.google.common.base.Stopwatch
import java.util.Random
import java.util.concurrent.TimeUnit
import org.eclipse.incquery.examples.cps.performance.tests.benchmark.BenchmarkResult
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper

class PublishSubscribeTest extends BasicScenarioXformTest {
	
	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override getScenario(Random rand) {
		new PublishSubscribeScenario(rand)
	}
	
	override getModificationLabel() {
		"Adding2NewClients"
	}
	
	override firstModification(CPSToDeployment cps2dep, BenchmarkResult result){
		info("Adding new host instance")
		var modifyTime1 = Stopwatch.createStarted;
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		var editTime1 = Stopwatch.createStarted;
		appType.prepareApplicationInstanceWithId("new.app.instance", hostInstance)
		editTime1.stop
		modifyTime1.stop
		result.addModificationTime(modifyTime1.elapsed(TimeUnit.MILLISECONDS))
		result.addEditTime(editTime1.elapsed(TimeUnit.MILLISECONDS))
	}
	
	
	override secondModification(CPSToDeployment cps2dep, BenchmarkResult result){
		info("Adding second new host instance")	
		var modifyTime2 = Stopwatch.createStarted;	
		var editTime2 = Stopwatch.createStarted;
		val appType = cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
		appType.prepareApplicationInstanceWithId("new.app.instance2", hostInstance)
		editTime2.stop
		modifyTime2.stop
		result.addModificationTime(modifyTime2.elapsed(TimeUnit.MILLISECONDS))
		result.addEditTime(editTime2.elapsed(TimeUnit.MILLISECONDS))
	}
}