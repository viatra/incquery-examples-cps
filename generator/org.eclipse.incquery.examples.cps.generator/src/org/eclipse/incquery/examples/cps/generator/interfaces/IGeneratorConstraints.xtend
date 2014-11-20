package org.eclipse.incquery.examples.cps.generator.interfaces


interface IGeneratorConstraints {
	def Iterable<IGenratorPhase> getSkippedPhases();
}