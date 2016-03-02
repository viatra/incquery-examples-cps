package org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications;

import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.statemachines.State;

public interface Application {
	
	State<?> getCurrentState();
	void stepToState(State nextState);
	
	boolean hasMessageFor(String trigger);
	public void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID);
	
	String getAppID();
	
}
