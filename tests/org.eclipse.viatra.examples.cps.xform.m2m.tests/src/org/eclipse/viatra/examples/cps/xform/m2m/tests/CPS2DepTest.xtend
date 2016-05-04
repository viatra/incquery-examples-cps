package org.eclipse.viatra.examples.cps.xform.m2m.tests

import com.google.common.collect.ImmutableSet
import org.eclipse.viatra.examples.cps.tests.PropertiesUtil
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper
import org.eclipse.viatra.examples.cps.xform.m2m.tests.wrappers.TransformationType
import org.junit.runners.Parameterized.Parameters

class CPS2DepTest extends CPS2DepTestWithoutParameters {

	new(CPSTransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	@Parameters(name = "{index}: {1}")
    public static def transformations() {
        
		xforms.map[
			#[it.wrapper, it.name].toArray
		]
    }
    
    static def getXforms() {
		val xformsBuilder = ImmutableSet.builder
		TransformationType.values.forEach[xformsBuilder.add(it)]
        val allXforms = xformsBuilder.build
		val disabledXforms = PropertiesUtil.disabledM2MTransformations
		
		return allXforms.filter[!disabledXforms.contains(it.name)].toSet
	}
}
