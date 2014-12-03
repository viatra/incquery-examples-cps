package org.eclipse.incquery.examples.cps.m2t.proto.simulation;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.eclipse.incquery.examples.cps.m2t.proto.elements.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.elements.Host;
import org.eclipse.incquery.examples.cps.m2t.proto.elements.State;
import org.eclipse.incquery.examples.cps.m2t.proto.elements.Transition;

public class Simulator {

	static List<Application> apps = new ArrayList<Application>();

	// The contents of this method will be generated
	public static void initDeployment() {

		// Host 1 creation

		Host host1 = new Host();

		Application storage = new Application();
		host1.addApp(storage);
		apps.add(storage);

		State issWait = new State();
		storage.addState(issWait);
		State issReceived = new State();
		storage.addState(issReceived);

		storage.setCurrent(issWait);

		Transition issFinish = new Transition();
		issReceived.addOutgoingTransition(issFinish);
		issFinish.setTargetState(issWait);
		Transition issReceiving = new Transition();
		issWait.addOutgoingTransition(issReceiving);
		issReceiving.setTargetState(issReceived);

		// Host 2 creation

		Host host2 = new Host();

		Application camera = new Application();
		host2.addApp(camera);
		apps.add(camera);

		State cInit = new State();
		camera.addState(cInit);
		State cSent = new State();
		camera.addState(cSent);

		camera.setCurrent(cInit);

		Transition cFinish = new Transition();
		cSent.addOutgoingTransition(cFinish);
		cFinish.setTargetState(cInit);
		Transition cSending = new Transition();
		cInit.addOutgoingTransition(cSending);
		cSending.setTargetState(cSent);
		cSending.setTriggeredTransition(issReceiving);

		Application alarm = new Application();
		host2.addApp(alarm);
		apps.add(alarm);

		State aInit = new State();
		alarm.addState(aInit);
		State aSent = new State();
		alarm.addState(aSent);

		alarm.setCurrent(aInit);

		Transition aFinish = new Transition();
		aSent.addOutgoingTransition(aFinish);
		aFinish.setTargetState(aInit);
		Transition aSending = new Transition();
		aInit.addOutgoingTransition(aSending);
		aSending.setTargetState(aSent);
		aSending.setTriggeredTransition(issReceiving);

		Application detector = new Application();
		host2.addApp(detector);
		apps.add(detector);

		State sdInit = new State();
		detector.addState(sdInit);
		State sdSent = new State();
		detector.addState(sdSent);

		detector.setCurrent(sdInit);

		Transition sdFinish = new Transition();
		sdSent.addOutgoingTransition(sdFinish);
		sdFinish.setTargetState(sdInit);
		Transition sdSending = new Transition();
		sdInit.addOutgoingTransition(sdSending);
		sdSending.setTargetState(sdSent);
		sdSending.setTriggeredTransition(issReceiving);

	}

	public static <E> void main(String[] args) {
		initDeployment();

		Iterator<Application> appIterator = apps.iterator();
		while (true) {
			
			if(appIterator.hasNext() == false){
				appIterator = apps.iterator();
			}
			
			Application app = appIterator.next();
			
			List<Transition> enabledTransitions = app.getCurrentState().getOutgoingTransitions();
			// Fire a transition (only one for each application), when
			// * enabled and triggers a transition that is also enabled (first priority) 
			// This case both the triggering and the triggered are fired
			for (Transition transition : enabledTransitions) {
				Transition triggeredTransition = transition.getTriggeredTransition();
				if (triggeredTransition != null) {

					State sourceState = triggeredTransition.getSourceState();
					Application targetApplication = sourceState.getApplication();
					if(sourceState == targetApplication.getCurrentState()) {
						app.setCurrent(transition.getTargetState());
						targetApplication.setCurrent(triggeredTransition.getTargetState());
						continue;
					}
				}
			}
			for (Transition transition : enabledTransitions) {
				Transition triggeredTransition = transition.getTriggeredTransition();
				// * enabled and triggers no transition (third priority)
				if (transition.getTriggeredTransition() == null && triggeredTransition == null) {					
						app.setCurrent(transition.getTargetState());
						continue;
				}
			}
		}


	}

}
