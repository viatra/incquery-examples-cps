package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.BehaviorSmokeDetectorB;


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
