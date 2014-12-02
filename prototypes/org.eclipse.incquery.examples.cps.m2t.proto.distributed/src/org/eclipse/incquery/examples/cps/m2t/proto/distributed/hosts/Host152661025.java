package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.communicationlayer.CommunicationNetwork;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.IBMSystemStorageApplication;

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
