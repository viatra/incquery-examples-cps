package org.eclipse.incquery.examples.cps.view;

import java.util.Collection;

import org.eclipse.incquery.examples.cps.model.viewer.util.AllHostInstancesQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.ConnectTypesAndInstancesHostQuerySpecification;
import org.eclipse.incquery.examples.cps.model.viewer.util.HostTypesQuerySpecification;
import org.eclipse.viatra.query.runtime.api.IQuerySpecification;
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException;

import com.google.common.collect.ImmutableSet;

public class CpsHardwareViewPart extends AbstractCpsViewPart {

	@Override
	protected Collection<IQuerySpecification<?>> getSpecifications()
			throws ViatraQueryException {
		return ImmutableSet.<IQuerySpecification<?>>of(
				//CommunicationsQuerySpecification.instance(),
				ConnectTypesAndInstancesHostQuerySpecification.instance(),
				AllHostInstancesQuerySpecification.instance(),
				HostTypesQuerySpecification.instance()
				);
	}

}
