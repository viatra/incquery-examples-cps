package org.eclipse.incquery.examples.cps.view;

import java.util.Collection;

import org.eclipse.gef4.layout.LayoutAlgorithm;
import org.eclipse.gef4.layout.algorithms.SpaceTreeLayoutAlgorithm;
import org.eclipse.incquery.examples.cps.model.viewer.util.AppInstancesNoAllocationQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.AppInstancesWithAllocationQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.ConnectAppQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.RequestsQuerySpecification;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.exception.IncQueryException;

import com.google.common.collect.ImmutableSet;

public class CpsRequirementViewPart extends AbstractCpsViewPart {

	protected LayoutAlgorithm getLayout() {
		return new SpaceTreeLayoutAlgorithm();
	}
	
	@Override
	protected Collection<IQuerySpecification<?>> getSpecifications()
			throws IncQueryException {
		return ImmutableSet.<IQuerySpecification<?>>of(
				AppInstancesNoAllocationQuerySpecification.instance(),
				AppInstancesWithAllocationQuerySpecification.instance(),
				ConnectAppQuerySpecification.instance(),
				RequestsQuerySpecification.instance());
	}

}
