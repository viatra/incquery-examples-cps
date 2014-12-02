package org.eclipse.incquery.examples.cps.m2t.proto.elements;

import java.util.ArrayList;
import java.util.List;

public class Host {
	private List<Application> apps = new ArrayList<Application>();
	
	public List<Application> getApps() {
		return apps;
	}
	
	public void addApp(Application app) {
		apps.add(app);
	}
}
