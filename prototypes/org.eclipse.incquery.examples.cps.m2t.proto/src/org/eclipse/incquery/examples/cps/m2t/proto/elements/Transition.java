package org.eclipse.incquery.examples.cps.m2t.proto.elements;


public class Transition {
	
	private State targetState;
	private State sourceState;
	
	private Transition triggeredTransition;
	private Transition triggeredBy;
	
	public void setTriggeredTransition(Transition t){
		triggeredTransition = t;
		t.triggeredBy = this;
	}
	
	public Transition getTriggeredTransition() {
		return triggeredTransition;
	}
	
	public void setTriggeredBy(Transition t){
		t.setTriggeredTransition(this);
	}
	
	public Transition getTriggeredBy() {
		return triggeredBy;
	}
	
	public State getTargetState() {
		return targetState;
	}

	public void setTargetState(State s) {
		targetState = s;
	}

	public State getSourceState() {
		return sourceState;
	}

	public void setSourceState(State sourceState) {
		this.sourceState = sourceState;
	}
	
	
}
