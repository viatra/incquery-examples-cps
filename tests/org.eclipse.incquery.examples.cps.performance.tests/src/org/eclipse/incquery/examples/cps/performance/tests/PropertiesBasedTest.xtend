package org.eclipse.incquery.examples.cps.performance.tests

import com.google.common.collect.ImmutableSet
import com.google.common.collect.Sets
import org.eclipse.incquery.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.config.TransformationType
import org.eclipse.incquery.examples.cps.tests.PropertiesUtil
import org.junit.runners.Parameterized.Parameters

abstract class PropertiesBasedTest extends CPSPerformanceTest {
	
	@Parameters(name = "{index}: xform: {0}, code generator: {2}, scale: {1}")
    public static def xformSizeGenerator() {
		val data = Sets::cartesianProduct(xforms,codegens)
       	data.map[ d |
	        scales.map[ scale |
        		#[d.get(0), scale, d.get(1)]
        	]
        ].flatten.map[it.toArray].toList
    }
	
	new(TransformationType wrapperType, int scale, GeneratorType generatorType, int runIndex) {
		super(wrapperType, scale, generatorType, runIndex)
	}
	
	new(TransformationType wrapperType,	int scale, GeneratorType generatorType) {
    	this(wrapperType, scale, generatorType,1)
	}
	
	static def getXforms() {
		val xformsBuilder = ImmutableSet.builder
		TransformationType.values.forEach[xformsBuilder.add(it)]
        val allXforms = xformsBuilder.build
		val disabledXforms = PropertiesUtil.disabledM2MTransformations
		
		return allXforms.filter[!disabledXforms.contains(it.name)].toSet
	}
	
	static def getCodegens() {
		val codegensBuilder = ImmutableSet.builder
		GeneratorType.values.forEach[codegensBuilder.add(it)]
		val allCodeGens = codegensBuilder.build
		val disabledCodegens = PropertiesUtil.disabledGeneratorTypes
		
		return allCodeGens.filter[!disabledCodegens.contains(it.name)].toSet
	}
	
	static def getScales() {
		return PropertiesUtil.enabledScales.map[Integer.valueOf(it)]
	}
}