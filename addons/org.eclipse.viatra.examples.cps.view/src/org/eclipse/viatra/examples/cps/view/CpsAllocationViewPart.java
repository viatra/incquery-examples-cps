package org.eclipse.viatra.examples.cps.view;

import java.util.Collection;

import org.eclipse.viatra.examples.cps.model.viewer.util.AllHostInstancesQuerySpecification;
import org.eclipse.viatra.examples.cps.model.viewer.util.AppInstancesNoAllocationQuerySpecification;
import org.eclipse.viatra.examples.cps.model.viewer.util.AppInstancesWithAllocationQuerySpecification;
import org.eclipse.viatra.examples.cps.model.viewer.util.ConnectAppAndHostQuerySpecification;
import org.eclipse.viatra.query.runtime.api.IQuerySpecification;
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException;

import com.google.common.collect.ImmutableSet;

public class CpsAllocationViewPart extends AbstractCpsViewPart {

	@Override
	protected Collection<IQuerySpecification<?>> getSpecifications() throws ViatraQueryException {
		return ImmutableSet.<IQuerySpecification<?>>of(
				AppInstancesNoAllocationQuerySpecification.instance(),
				AppInstancesWithAllocationQuerySpecification.instance(),
				ConnectAppAndHostQuerySpecification.instance(),
				AllHostInstancesQuerySpecification.instance());
	}	
}
