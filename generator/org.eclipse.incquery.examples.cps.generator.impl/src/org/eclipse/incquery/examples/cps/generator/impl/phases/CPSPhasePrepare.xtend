package org.eclipse.incquery.examples.cps.generator.impl.phases

import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.interfaces.IGenratorPhase
import com.google.common.collect.ImmutableList
import org.eclipse.incquery.examples.cps.generator.interfaces.IGeneratorOperation
import org.eclipse.incquery.examples.cps.generator.impl.queries.Queries

class CPSPhasePrepare implements IGenratorPhase<CyberPhysicalSystem, CPSFragment> {
	
	override getOperations(CPSFragment fragment) {
		return ImmutableList.of(new IGeneratorOperation<CyberPhysicalSystem, CPSFragment>{
			override execute(CPSFragment fr) {
				Queries.instance.prepare(fr.engine);
				true;
			}
		});
	}
	
}