package org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.statemachines.State;

public interface Host {

	Iterable<State> calculatePossibleNextStates();
	boolean hasMessageFor(String appID, String trigger);
	void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID);
	void receiveTrigger(String trgAppID, String trgTransactionID);
	
	Iterable<Application> getApplications();
}
