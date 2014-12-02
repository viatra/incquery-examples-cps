package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.BehaviorISSBState;


public class IBMSystemStorageApplication extends BaseApplication<BehaviorISSBState> {

	protected static final String APP_ID = "IBM System Storage";

	public IBMSystemStorageApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorISSBState.ISSWait;
	}
	
}
