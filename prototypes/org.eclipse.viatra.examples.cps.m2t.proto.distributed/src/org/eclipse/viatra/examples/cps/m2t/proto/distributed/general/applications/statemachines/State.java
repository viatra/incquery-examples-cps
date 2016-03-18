package org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.statemachines;

import java.util.List;

import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.Application;

public interface State<StateType extends State> {
	List<State<StateType>> possibleNextStates(Application app);
	StateType stepTo(StateType nextState, Application app);
}
