package org.eclipse.viatra.examples.cps.m2t.proto.distributed.generated.applications;

import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.BaseApplication;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.hosts.Host;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.generated.hosts.statemachines.BehaviorSmokeDetectorB;


public class SmokeDetectorApplication extends BaseApplication<BehaviorSmokeDetectorB> {

	protected static final String APP_ID = "Smoke Detector";

	public SmokeDetectorApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorSmokeDetectorB.SDInit;
	}
	
	@Override
	public String getAppID() {
		return APP_ID;
	}
	
}
