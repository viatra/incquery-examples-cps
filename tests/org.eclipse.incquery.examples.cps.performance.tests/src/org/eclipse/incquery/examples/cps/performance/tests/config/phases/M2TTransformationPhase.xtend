package org.eclipse.incquery.examples.cps.performance.tests.config.phases

import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.incquery.examples.cps.performance.tests.config.CPSDataToken
import org.eclipse.incquery.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.jdt.CodeGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorUtil
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.emf.EMFScope

class M2TTransformationPhase extends AtomicPhase {

	new(String name) {
		super(name)
	}

	override execute(DataToken token, PhaseResult phaseResult) {
		val cpsToken = token as CPSDataToken
		val timer = new TimeMetric("Time")
		val memory = new MemoryMetric("Memory")

		timer.startMeasure

		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cpsToken.cps2dep))

		val projectName = "integration.test.generated.code"
		var ICPSGenerator codeGenerator = null
		if (cpsToken.generatorType.equals(GeneratorType.DISTRIBUTED)) {
			codeGenerator = new org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator(projectName, engine, true);
		} else if (cpsToken.generatorType.equals(GeneratorType.JDT_BASED)) {
			codeGenerator = new CodeGenerator(projectName, engine);
		}
		cpsToken.codeGenerator = codeGenerator
		val IProject project = GeneratorHelper.createProject(projectName)
		val srcFolder = project.getFolder("src");
		cpsToken.srcFolder = srcFolder
		val monitor = new NullProgressMonitor();
		if (!srcFolder.exists()) {
			srcFolder.create(true, true, monitor);
		}

		// Source generation
		GeneratorUtil.generateAll(cpsToken.cps2dep.deployment, codeGenerator, srcFolder)
		timer.stopMeasure
		memory.measure

		phaseResult.addMetrics(timer, memory)
	}

}