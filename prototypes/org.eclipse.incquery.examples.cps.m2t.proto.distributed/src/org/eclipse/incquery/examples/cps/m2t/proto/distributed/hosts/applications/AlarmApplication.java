package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.BehaviorAlarmB;


public class AlarmApplication extends BaseApplication<BehaviorAlarmB> {

	protected static final String APP_ID = "Alarm";

	public AlarmApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorAlarmB.AInit;
	}
	
}
