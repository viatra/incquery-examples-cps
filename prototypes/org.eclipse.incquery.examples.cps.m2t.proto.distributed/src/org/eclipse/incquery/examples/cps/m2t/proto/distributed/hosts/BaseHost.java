package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.State;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Lists;
import com.google.common.collect.Table;

public abstract class BaseHost implements Host{

	protected static Logger logger = Logger.getLogger("cps.proto.distributed.hostengine");
	
	// Table<AppID, TriggerID, Date>
	protected Table<String, String, Date> triggers = HashBasedTable.create();
	
	// Applications
	protected List<Application> applications;
	
	public Iterable<State> calculatePossibleNextStates(){
		List<State> states = Lists.newArrayList();

		for (Application app : applications) {
			states.addAll(app.getCurrentState().possibleNextStates(app));
		}
		
		return states;
	}

	@Override
	public boolean hasMessageFor(String appID, String trigger) {
		logger.info("Has message for " + trigger + "?  --> FALSE" );
		// TODO Implement
		return false;
	}

	@Override
	public void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID) {
		logger.info("Send trigger to " + trgHostIP + " : " + trgAppID + " : " + trgTransactionID);
		// TODO Implement
	}
	
	
	@Override
	public synchronized void receiveTrigger(String trgAppID, String trgTransactionID) {
		triggers.put(trgAppID, trgTransactionID, new Date());
	}
	
}
