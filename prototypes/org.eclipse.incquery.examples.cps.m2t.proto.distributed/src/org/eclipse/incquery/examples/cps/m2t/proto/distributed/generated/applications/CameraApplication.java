package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.BaseApplication;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.hosts.statemachines.BehaviorCameraB;


public class CameraApplication extends BaseApplication<BehaviorCameraB> {

	protected static final String APP_ID = "Camera";

	public CameraApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorCameraB.CInit;
	}
	
	@Override
	public String getAppID() {
		return APP_ID;
	}
	
}
