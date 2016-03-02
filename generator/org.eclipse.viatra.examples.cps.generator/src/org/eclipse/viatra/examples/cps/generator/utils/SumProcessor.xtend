package org.eclipse.viatra.examples.cps.generator.utils

import org.eclipse.viatra.query.runtime.base.api.IEClassifierProcessor.IEClassProcessor
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.viatra.query.runtime.base.api.IEStructuralFeatureProcessor
import org.eclipse.emf.ecore.EStructuralFeature

class SumProcessor implements IEClassProcessor,  IEStructuralFeatureProcessor {
	
	var sum = 0;
		
	override process(EClass type, EObject instance) {
		sum++
	}
	
	override process(EStructuralFeature feature, EObject source, Object target) {
		sum++
	}
	
	def getSum(){
		return sum
	}
	
	def resetSum(){
		sum = 0
	}
		
}