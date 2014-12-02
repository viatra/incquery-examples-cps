package org.eclipse.incquery.examples.cps.m2t.proto.elements;

import java.util.ArrayList;
import java.util.List;

public class State {
	private List<Transition> outgoingTransitions = new ArrayList<Transition>();
	public void addOutgoingTransition(Transition t) {
		outgoingTransitions.add(t);
	}
}
