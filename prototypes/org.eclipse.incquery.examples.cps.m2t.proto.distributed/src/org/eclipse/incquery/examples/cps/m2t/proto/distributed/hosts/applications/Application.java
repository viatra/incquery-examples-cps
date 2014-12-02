package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.State;

public interface Application {
	
	State<?> getCurrentState();
	
	boolean hasMessageFor(String trigger);
	public void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID);
	
}
