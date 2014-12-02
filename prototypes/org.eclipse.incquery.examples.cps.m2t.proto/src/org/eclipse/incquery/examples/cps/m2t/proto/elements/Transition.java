package org.eclipse.incquery.examples.cps.m2t.proto.elements;

import java.util.ArrayList;
import java.util.List;

public class Transition {
	
	private State targetState;
	
	private List<Transition> triggeredTransitions;
	private Transition triggeredBy;
	
	public Transition() {
		triggeredTransitions = new ArrayList<Transition>();
	}
	
	public void addTriggeredTransition(Transition t){
		triggeredTransitions.add(t);
		t.triggeredBy = this;
	}
	
	public void setTrigger(Transition t){
		t.addTriggeredTransition(this);
	}
	
	public Transition getTriggeredBy() {
		return triggeredBy;
	}
	
	public void setTargetState(State s) {
		targetState = s;
	}
	
	public State getTargetState() {
		return targetState;
	}
	
	
}
