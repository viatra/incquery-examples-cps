package org.eclipse.viatra.examples.cps.generator.phases

import com.google.common.collect.ImmutableList
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.generator.queries.Queries
import org.eclipse.viatra.examples.cps.planexecutor.api.IOperation
import org.eclipse.viatra.examples.cps.planexecutor.api.IPhase

class CPSPhasePrepare implements IPhase<CPSFragment> {
	
	override getOperations(CPSFragment fragment) {
		return ImmutableList.of(new IOperation<CPSFragment>{
			override execute(CPSFragment fr) {
				Queries.instance.prepare(fr.engine);
				true;
			}
		});
	}
	
}