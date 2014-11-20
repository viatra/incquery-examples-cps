package org.eclipse.incquery.examples.cps.generator.impl.phases

import com.google.common.collect.ImmutableList
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.queries.Queries
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IOperation
import org.eclipse.incquery.examples.cps.planexecutor.interfaces.IPhase

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