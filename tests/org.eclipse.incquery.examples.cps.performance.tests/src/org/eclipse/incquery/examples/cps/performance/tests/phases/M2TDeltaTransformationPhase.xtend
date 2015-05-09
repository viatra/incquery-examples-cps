package org.eclipse.incquery.examples.cps.performance.tests.phases

import com.google.common.base.CaseFormat
import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.performance.tests.CPSDataToken
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper

class M2TDeltaTransformationPhase extends AtomicPhase {

	new(String name) {
		super(name)
	}

	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val timer = new TimeMetric("Time")
		val memory = new MemoryMetric("Memory")

		timer.startMeasure

		val monitor = cpsToken.changeMonitor
		val generator = cpsToken.codeGenerator
		val folder = cpsToken.srcFolder

		if (monitor.deltaSinceLastCheckpoint.oldNamesForDeletion != null) {
			for (depElem : monitor.deltaSinceLastCheckpoint?.oldNamesForDeletion?.keySet) {
				if (depElem instanceof DeploymentApplication) {
					// TODO Delete corresponding .java file
				} else if (depElem instanceof DeploymentHost) {
					// TODO Delete corresponding .java file
				}
			}
		}
		for (appeared : monitor.deltaSinceLastCheckpoint.appeared) {
			if (appeared instanceof DeploymentApplication) {
				val app = appeared as DeploymentApplication
				GeneratorHelper.createFile(folder, purify(app.id) + "Application.java", false,
					generator.generateApplicationCode(app), true);
			}
			if (appeared instanceof DeploymentHost) {
				val host = appeared as DeploymentHost
				GeneratorHelper.createFile(folder, "Host" + purify(host.ip) + ".java", false,
					generator.generateHostCode(host), true);
			}
			if (appeared instanceof DeploymentBehavior) {
				val behavior = appeared as DeploymentBehavior
				GeneratorHelper.createFile(folder, "Behavior" + purify(behavior.description) + ".java", false,
					generator.generateBehaviorCode(behavior), true);
			}
		}

		timer.stopMeasure
		memory.measure

		phaseResult.addMetrics(timer, memory)
	}
	
	private def purify(String string) {
		var String str = string.replace(' ', '_').toLowerCase.replaceAll("[^A-Za-z0-9]", "")
		return CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, str);
	}

}