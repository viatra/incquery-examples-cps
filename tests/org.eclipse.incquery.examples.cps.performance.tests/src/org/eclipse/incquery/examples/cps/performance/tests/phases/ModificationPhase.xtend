package org.eclipse.incquery.examples.cps.performance.tests.phases

import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase
import org.eclipse.incquery.examples.cps.benchmark.DataToken
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil

class ModificationPhase extends AtomicPhase{
	
	extension CPSModelBuilderUtil builderUtil
	
	new(String name) {
		super(name)
		builderUtil = new CPSModelBuilderUtil
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
//		info("Adding new host instance")
//		var modifyTime1 = Stopwatch.createStarted;
		val appType = cpsToken.cps2dep.cps.appTypes.findFirst[it.id.contains("Client")]
		val hostInstance = cpsToken.cps2dep.cps.hostTypes.findFirst[it.id.contains("client")].instances.head
//		var editTime1 = Stopwatch.createStarted;
		val index = cpsToken.modificationIndex
		val appID = if (index == 1) "new.app.instance" else "new.app.instance" + index 
		appType.prepareApplicationInstanceWithId(appID, hostInstance)
//		editTime1.stop
//		modifyTime1.stop
//		result.addModificationTime(modifyTime1.elapsed(TimeUnit.MILLISECONDS))
//		result.addEditTime(editTime1.elapsed(TimeUnit.MILLISECONDS))
	}
	
}