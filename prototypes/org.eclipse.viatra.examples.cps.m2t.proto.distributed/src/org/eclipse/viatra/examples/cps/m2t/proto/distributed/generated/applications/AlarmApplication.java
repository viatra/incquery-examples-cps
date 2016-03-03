package org.eclipse.viatra.examples.cps.m2t.proto.distributed.generated.applications;

import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.BaseApplication;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.hosts.Host;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.generated.hosts.statemachines.BehaviorAlarmB;


public class AlarmApplication extends BaseApplication<BehaviorAlarmB> {

	protected static final String APP_ID = "Alarm";

	public AlarmApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorAlarmB.AInit;
	}

	@Override
	public String getAppID() {
		return APP_ID;
	}
	
}
