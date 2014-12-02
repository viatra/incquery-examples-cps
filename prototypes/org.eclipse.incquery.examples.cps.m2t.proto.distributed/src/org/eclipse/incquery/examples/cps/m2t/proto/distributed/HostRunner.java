package org.eclipse.incquery.examples.cps.m2t.proto.distributed;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.Host;

public class HostRunner {

	Host host;
	
	public HostRunner(Host host) {
		this.host = host;
	}
		
	public boolean hasHost() {
		return true;
	}

	public Host getHost() {
		return host;
	}

}
