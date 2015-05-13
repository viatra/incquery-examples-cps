package org.eclipse.incquery.examples.cps.performance.tests.config.scenarios

import eu.mondo.sam.core.results.CaseDescriptor
import eu.mondo.sam.core.scenarios.BenchmarkScenario
import org.eclipse.incquery.examples.cps.generator.utils.RandomUtils
import org.eclipse.incquery.examples.cps.performance.tests.config.cases.BenchmarkCase

abstract class CPSBenchmarkScenario extends BenchmarkScenario {
	protected extension RandomUtils randUtil = new RandomUtils;
	protected BenchmarkCase benchmarkCase;
	
	new(BenchmarkCase benchmarkCase) {
		this.benchmarkCase = benchmarkCase
		this.size = benchmarkCase.scale
		this.caseName = benchmarkCase.class.simpleName
		this.runIndex = 1
	}
	
	override getCaseDescriptor() {
		val descriptor = new CaseDescriptor
		descriptor.tool = this.tool
		descriptor.caseName = this.caseName
		descriptor.size = this.size
		descriptor.runIndex = this.runIndex
		descriptor.scenario = this.name
		return descriptor
	}
	
	def String getName()
}