package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.communicationlayer.CommunicationNetwork;
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

	private CommunicationNetwork network;
	
	
	public BaseHost(CommunicationNetwork network) {
		this.network = network;
	}
	
	public Iterable<State> calculatePossibleNextStates(){
		List<State> states = Lists.newArrayList();

		for (Application app : applications) {
			states.addAll(app.getCurrentState().possibleNextStates(app));
		}
		
		return states;
	}

	@Override
	public boolean hasMessageFor(String appID, String trigger) {
		Map<String, Date> appTriggers = triggers.row(appID);
		logger.info("Has message for " + trigger + "?  --> " + appTriggers.containsKey(trigger));
		
		return appTriggers.containsKey(trigger);
	}

	@Override
	public void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID) {
		logger.info("Send trigger to " + trgHostIP + " : " + trgAppID + " : " + trgTransactionID);

		network.sendTrigger(trgHostIP, trgAppID, trgTransactionID);
	}
	
	
	@Override
	public synchronized void receiveTrigger(String trgAppID, String trgTransactionID) {
		logger.info("Received trigger[ AppID: " + trgAppID + ", TriggerID: " + trgTransactionID + "]");
		
		triggers.put(trgAppID, trgTransactionID, new Date());
	}
	
	@Override
	public Iterable<Application> getApplications(){
		return applications;
	}
	
}
