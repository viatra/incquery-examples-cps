package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.hosts;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.communicationlayer.CommunicationNetwork;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.BaseHost;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications.AlarmApplication;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications.CameraApplication;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications.SmokeDetectorApplication;

import com.google.common.collect.Lists;


public class Host152661026 extends BaseHost {
	
	public Host152661026(CommunicationNetwork network) {
		super(network);
		// Add Applications of Host
		applications = Lists.<Application>newArrayList(
				new CameraApplication(this),
				new AlarmApplication(this),
				new SmokeDetectorApplication(this)				
		);
	}

} 
