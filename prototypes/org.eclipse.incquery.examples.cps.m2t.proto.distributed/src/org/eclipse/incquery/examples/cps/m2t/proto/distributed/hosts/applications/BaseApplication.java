package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines.State;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;

public class BaseApplication<StateType extends State> implements Application {

	private static Logger logger = Logger.getLogger("cps.proto.distributed.application");
	
	// Table<AppID, TriggerID, Date>
	Table<String, String, Date> triggers = HashBasedTable.create();
	
	// Applications
	List<Application> applications;
	
	protected StateType currentState;
	protected Host host;

	// Add current ApplicationID
	protected static final String APP_ID = "";
	
	public BaseApplication(Host host) {
		this.host = host;
	}
	
	@Override
	public StateType getCurrentState() {
		return currentState;
	}

	@Override
	public boolean hasMessageFor(String trigger) {
		return host.hasMessageFor(APP_ID, trigger);
	}

	@Override
	public void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID) {
		host.sendTrigger(trgHostIP, trgAppID, trgTransactionID);
	}

}
