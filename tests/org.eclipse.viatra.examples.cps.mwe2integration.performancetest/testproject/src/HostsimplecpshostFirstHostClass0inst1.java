package testproject.hosts;

import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.Application;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.communicationlayer.CommunicationNetwork;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.hosts.BaseHost;
import com.google.common.collect.Lists;

public class HostSimplecpshostfirsthostclass0inst1 extends BaseHost {

	public HostSimplecpshostfirsthostclass0inst1(CommunicationNetwork network) {
		super(network);
		// Add Applications of Host
		applications = Lists.<Application>newArrayList(
		);
	}
}
