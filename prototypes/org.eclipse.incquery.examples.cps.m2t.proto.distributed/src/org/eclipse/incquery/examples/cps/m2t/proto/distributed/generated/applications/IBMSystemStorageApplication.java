package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.BaseApplication;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.hosts.statemachines.BehaviorISSBState;


public class IBMSystemStorageApplication extends BaseApplication<BehaviorISSBState> {

	// Set ApplicationID
	protected static final String APP_ID = "IBM System Storage";

	public IBMSystemStorageApplication(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorISSBState.ISSWait;
	}
	
	@Override
	public String getAppID() {
		return APP_ID;
	}
	
}
