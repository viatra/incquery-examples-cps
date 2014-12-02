package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines;

import java.util.List;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.Application;

import com.google.common.collect.Lists;

public enum BehaviorSmokeDetectorB implements State<BehaviorSmokeDetectorB> {
	 ///////////
	// States
	SDInit {
        @Override
        public List<BehaviorSmokeDetectorB> possibleNextStates(Application app) {
        	List<BehaviorSmokeDetectorB> possibleStates = Lists.newArrayList();
        	
        	// Add Neutral Transitions
        	
        	// Add Send Transitions
        	possibleStates.add(SDSent);
        	
        	// Add Wait Transitions
        	
        	return possibleStates;
        }
        
        @Override
        public BehaviorSmokeDetectorB stepTo(BehaviorSmokeDetectorB nextState, Application app) {
        	// Send triggers
        	if(nextState == SDSent){
        		// Send to all corresponding App Instances on all Host Instances (send to N waiter)
        		app.sendTrigger("152.6.102.5", "IBM System Storage", "ISSReceiving");
        		return nextState;
        	}
        	
        	// Other cases (wait, neutral)
        	return super.stepTo(nextState, app);
        }
    },
    SDSent {
        @Override
        public List<BehaviorSmokeDetectorB> possibleNextStates(Application app) {
        	List<BehaviorSmokeDetectorB> possibleStates = Lists.newArrayList();
        	
        	// Add Neutral Transitions
        	possibleStates.add(SDInit);
        	
        	// Add Send Transitions
        	        	
        	// Add Wait Transitions
        	
        	return possibleStates;
        }
    };
	
     ////////////
    // Triggers
    
	 /////////////////
	// General part
	abstract public List<BehaviorSmokeDetectorB> possibleNextStates(Application app);
	
	public BehaviorSmokeDetectorB stepTo(BehaviorSmokeDetectorB nextState, Application app){
		if(possibleNextStates(app).contains(nextState)){
			return nextState;
		}
		return this;
	}

}
