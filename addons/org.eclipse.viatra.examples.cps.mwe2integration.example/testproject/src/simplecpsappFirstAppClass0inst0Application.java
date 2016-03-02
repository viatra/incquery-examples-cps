package testproject.applications;
	
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.BaseApplication;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.hosts.Host;

import testproject.hosts.statemachines.BehaviorSimplecpsappfirstappclass0inst0;


public class Simplecpsappfirstappclass0inst0Application extends BaseApplication<BehaviorSimplecpsappfirstappclass0inst0> {

	// Set ApplicationID
	protected static final String APP_ID = "simple.cps.app.FirstAppClass0.inst0";

	public Simplecpsappfirstappclass0inst0Application(Host host) {
		super(host);
		
		// Set initial State
		currentState = BehaviorSimplecpsappfirstappclass0inst0.Simplecpsappfirstappclass0sm0s0;
	}
	
	@Override
	public String getAppID() {
		return APP_ID;
	}
	
}
