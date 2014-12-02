package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.AlarmApplication;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.CameraApplication;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.SmokeDetectorApplication;

import com.google.common.collect.Lists;


public class Host152661026 extends BaseHost {
	
	public Host152661026() {
		// Add Applications of Host
		applications = Lists.<Application>newArrayList(
				new CameraApplication(this),
				new AlarmApplication(this),
				new SmokeDetectorApplication(this)				
		);
	}

} 
