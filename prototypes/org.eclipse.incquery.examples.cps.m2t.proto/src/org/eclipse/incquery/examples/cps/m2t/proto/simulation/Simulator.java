package org.eclipse.incquery.examples.cps.m2t.proto.simulation;

import java.util.ArrayList;
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
		
		
	}

}
