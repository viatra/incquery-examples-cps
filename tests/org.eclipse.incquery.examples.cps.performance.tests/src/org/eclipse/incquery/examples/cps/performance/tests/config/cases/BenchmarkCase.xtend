package org.eclipse.incquery.examples.cps.performance.tests.config.cases

import eu.mondo.sam.core.phases.BenchmarkPhase
import java.util.Random

abstract class BenchmarkCase {
	public int scale
	public Random rand
	
	new(int scale, Random rand) {
		this.scale = scale
		this.rand = rand
	}
	
	def BenchmarkPhase getGenerationPhase(String phaseName)
	def BenchmarkPhase getModificationPhase(String phaseName)
}