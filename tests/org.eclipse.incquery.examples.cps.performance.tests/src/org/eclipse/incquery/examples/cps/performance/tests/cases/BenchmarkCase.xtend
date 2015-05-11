package org.eclipse.incquery.examples.cps.performance.tests.cases

import eu.mondo.sam.core.phases.BenchmarkPhase

abstract class BenchmarkCase {
	def BenchmarkPhase getGenerationPhase(String name)
	def BenchmarkPhase getModificationPhase(String name)
}