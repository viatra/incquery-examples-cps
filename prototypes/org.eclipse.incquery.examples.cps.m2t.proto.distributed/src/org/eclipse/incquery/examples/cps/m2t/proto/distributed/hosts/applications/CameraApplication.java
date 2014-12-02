package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.BehaviorCameraB;


public class CameraApplication extends BaseApplication<BehaviorCameraB> {

	protected static final String APP_ID = "Camera";

	public CameraApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorCameraB.CInit;
	}
	
}
