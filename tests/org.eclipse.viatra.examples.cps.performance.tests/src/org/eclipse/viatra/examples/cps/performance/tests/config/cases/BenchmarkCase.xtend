/*******************************************************************************
 * Copyright (c) 2014, 2016, IncQuery Labs Ltd.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Tamas Borbas, Marton Bur, Zoltan Ujhelyi, Daniel Segesdi, Zsolt Kovari - initial API and implementation
 *******************************************************************************/

package org.eclipse.viatra.examples.cps.performance.tests.config.cases

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