package org.eclipse.incquery.examples.cps.view;

import java.util.Collection;

import org.eclipse.incquery.examples.cps.model.viewer.util.AllHostInstancesQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.AppInstancesNoAllocationQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.AppInstancesWithAllocationQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.ConnectAppAndHostQuerySpecification;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.exception.IncQueryException;

import com.google.common.collect.ImmutableSet;

public class CpsAllocationViewPart extends AbstractCpsViewPart {

	@Override
	protected Collection<IQuerySpecification<?>> getSpecifications() throws IncQueryException {
		return ImmutableSet.<IQuerySpecification<?>>of(
				AppInstancesNoAllocationQuerySpecification.instance(),
				AppInstancesWithAllocationQuerySpecification.instance(),
				ConnectAppAndHostQuerySpecification.instance(),
				AllHostInstancesQuerySpecification.instance());
	}	
}
