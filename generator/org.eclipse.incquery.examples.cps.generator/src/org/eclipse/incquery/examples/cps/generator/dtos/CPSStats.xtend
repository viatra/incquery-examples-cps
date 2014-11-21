package org.eclipse.incquery.examples.cps.generator.dtos

import org.eclipse.incquery.examples.cps.generator.queries.TransitionMatcher
import org.eclipse.incquery.examples.cps.generator.queries.AllocatedAppInstancesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.AppInstancesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.AppTypesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.ConnectedHostsMatcher
import org.eclipse.incquery.examples.cps.generator.queries.HostInstancesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.HostTypesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.StatesMatcher
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem

class CPSStats {
	
	public int appTypeCount = 0;
	public int appInstanceCount = 0;
	public int hostTypeCount = 0;
	public int hostInstanceCount = 0;
	public int stateCount = 0;
	public int transitionCount = 0;
	public int allocatedAppCount = 0;
	public int connectedHostCount = 0;
	public int eObjects = 0;

	new(IncQueryEngine engine, CyberPhysicalSystem model){
		this.appTypeCount = AppTypesMatcher.on(engine).countMatches;
		this.appInstanceCount = AppInstancesMatcher.on(engine).countMatches;
		this.hostTypeCount = HostTypesMatcher.on(engine).countMatches;
		this.hostInstanceCount = HostInstancesMatcher.on(engine).countMatches;
		this.stateCount = StatesMatcher.on(engine).countMatches;
		this.transitionCount = TransitionMatcher.on(engine).countMatches;
		this.allocatedAppCount = AllocatedAppInstancesMatcher.on(engine).countMatches;
		this.connectedHostCount = ConnectedHostsMatcher.on(engine).countMatches;
		this.eObjects = model.eAllContents.size;
		
	}
}