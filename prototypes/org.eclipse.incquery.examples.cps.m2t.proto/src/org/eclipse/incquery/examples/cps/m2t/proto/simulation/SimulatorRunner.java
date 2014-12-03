package org.eclipse.incquery.examples.cps.m2t.proto.simulation;

public class SimulatorRunner {

	public static void main(String[] args) {
		Simulator simulator = new Simulator();
		simulator.initDeployment();
		while (true) {
			simulator.stepSimulation();
		}
	}

}
