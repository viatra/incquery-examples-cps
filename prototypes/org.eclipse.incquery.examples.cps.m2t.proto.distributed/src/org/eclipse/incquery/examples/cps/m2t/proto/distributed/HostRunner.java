package org.eclipse.incquery.examples.cps.m2t.proto.distributed;

import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;

public class HostRunner implements Runnable  {

	private static Logger logger = Logger.getLogger("cps.proto.distributed.hostrunner");

	Host host;
	
	public HostRunner(Host host) {
		this.host = host;
	}
		
	public boolean hasHost() {
		return host != null;
	}

	public Host getHost() {
		return host;
	}

	@Override
	public void run() {
		logger.info("Start running with " + host.getClass().getSimpleName());
	}

}
