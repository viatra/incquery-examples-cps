package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines;

import java.util.List;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.Application;

public interface State<StateType extends State> {
	List<StateType> possibleNextStates(Application app);
	StateType stepTo(StateType nextState, Application app);
}
