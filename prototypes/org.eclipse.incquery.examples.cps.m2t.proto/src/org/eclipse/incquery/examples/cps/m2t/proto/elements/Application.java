package org.eclipse.incquery.examples.cps.m2t.proto.elements;

import java.util.ArrayList;
import java.util.List;

public class Application {
	
	private List<State> states = new ArrayList<State>();
	private State currentState;
	
	private List<Transition> transitions;
	
	public void addState(State s) {
		states.add(s);
		s.setApplication(this);
	}
	
	public void addTransition(Transition t) {
		transitions.add(t);
	}
	
	public State getCurrentState() {
		return currentState;
	}

	public void setCurrent(State s) {
		this.currentState = s;
	}
	
	
}
