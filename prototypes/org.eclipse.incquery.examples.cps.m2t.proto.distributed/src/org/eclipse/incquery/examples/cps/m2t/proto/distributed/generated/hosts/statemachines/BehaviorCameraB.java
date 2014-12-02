package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated.hosts.statemachines;

import java.util.List;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.statemachines.State;

import com.google.common.collect.Lists;

public enum BehaviorCameraB implements State<BehaviorCameraB>{
	 ///////////
	// States
	CInit {
        @Override
        public List<State<BehaviorCameraB>> possibleNextStates(Application app) {
        	List<State<BehaviorCameraB>> possibleStates = Lists.newArrayList();
        	
        	// Add Neutral Transitions
        	
        	// Add Send Transitions
        	possibleStates.add(CSent);
        	
        	// Add Wait Transitions
        	
        	return possibleStates;
        }
        
        @Override
        public BehaviorCameraB stepTo(BehaviorCameraB nextState, Application app) {
        	// Send triggers
        	if(nextState == CSent){
        		app.sendTrigger("152.66.102.5", "IBM System Storage", "ISSReceiving");
        		return nextState;
        	}
        	
        	// Other cases (wait, neutral)
        	return super.stepTo(nextState, app);
        }
    },
    CSent {
        @Override
        public List<State<BehaviorCameraB>> possibleNextStates(Application app) {
        	List<State<BehaviorCameraB>> possibleStates = Lists.newArrayList();
        	
        	// Add Neutral Transitions
        	possibleStates.add(CInit);
        	
        	// Add Send Transitions
        	        	
        	// Add Wait Transitions
        	
        	return possibleStates;
        }
    };
	
     ////////////
    // Triggers
    
	 /////////////////
	// General part
	@Override
	abstract public List<State<BehaviorCameraB>> possibleNextStates(Application app);
	
	@Override
	public BehaviorCameraB stepTo(BehaviorCameraB nextState, Application app){
		if(possibleNextStates(app).contains(nextState)){
			return nextState;
		}
		return this;
	}

}
