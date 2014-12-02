package org.eclipse.incquery.examples.cps.m2t.proto.distributed.communicationlayer;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.HostRunner;

public class CommunicationNetwork {
	private static Logger logger = Logger.getLogger("cps.proto.distributed.commnetwork"); 
	
	Map<String, HostRunner> hosts = new HashMap<String, HostRunner>();
	
	public void addHost(String ipAddress, HostRunner hostRunner){
		logger.info("Host added: " + ipAddress);
		hosts.put(ipAddress, hostRunner);
	}
	
	public void removeHost(String ipAddress){
		hosts.remove(ipAddress);
	}
	
	public synchronized void sendTrigger(String trgHostIP, String trgAppID, String trgTransactionID){
		HostRunner hostRunner = hosts.get(trgHostIP);
		if(hostRunner != null && hostRunner.hasHost()){
			hostRunner.getHost().receiveTrigger(trgAppID, trgTransactionID);
		}else{
			logger.info("Unknown ip adderss (" + trgHostIP + ") or dormant host");
		}
	}
	
}
