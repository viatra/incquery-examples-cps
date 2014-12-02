package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.State;

public interface Application {
	
	State<?> getCurrentState();
	void stepToState(State nextState);
	
	boolean hasMessageFor(String trigger);
	public void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID);
	
	String getAppID();
	
}
