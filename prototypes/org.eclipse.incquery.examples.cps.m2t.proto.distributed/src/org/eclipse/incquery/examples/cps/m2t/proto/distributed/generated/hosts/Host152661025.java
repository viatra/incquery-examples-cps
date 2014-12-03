package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.hosts;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.communicationlayer.CommunicationNetwork;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.BaseHost;
// Add imports for applications
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications.IBMSystemStorageApplication;

import com.google.common.collect.Lists;


public class Host152661025 extends BaseHost {
	
	public Host152661025(CommunicationNetwork network) {
		super(network);
		// Add Applications of Host
		applications = Lists.<Application>newArrayList(
				new IBMSystemStorageApplication(this)
		);
	}

} 
