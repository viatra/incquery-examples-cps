package org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.statemachines;

import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.hosts.applications.Application;

import com.google.common.collect.Lists;

public enum BehaviorAlarmB implements State<BehaviorAlarmB> {
	 ///////////
	// States
	AInit {
        @Override
        public List<BehaviorAlarmB> possibleNextStates(Application app) {
        	List<BehaviorAlarmB> possibleStates = Lists.newArrayList();
        	
        	// Add Neutral Transitions
        	
        	// Add Send Transitions
        	possibleStates.add(ASent);
        	
        	// Add Wait Transitions
        	
        	return possibleStates;
        }
        
        @Override
        public BehaviorAlarmB stepTo(BehaviorAlarmB nextState, Application app) {
        	// Send triggers
        	if(nextState == ASent){
        		app.sendTrigger("152.6.102.5", "IBM System Storage", "ISSReceiving");
        		return super.stepTo(nextState, app); // TODO remove--> else if needed!
        	}
        	
        	// Other cases (wait, neutral)
        	return super.stepTo(nextState, app);
        }
    },
    ASent {
        @Override
        public List<BehaviorAlarmB> possibleNextStates(Application app) {
        	List<BehaviorAlarmB> possibleStates = Lists.newArrayList();
        	
        	// Add Neutral Transitions
        	possibleStates.add(AInit);
        	
        	// Add Send Transitions
        	        	
        	// Add Wait Transitions
        	
        	return possibleStates;
        }
    };
	
    private static Logger logger = Logger.getLogger("cps.proto.distributed.state");
    
     ////////////
    // Triggers
    
	 /////////////////
	// General part
	@Override
	abstract public List<BehaviorAlarmB> possibleNextStates(Application app);
	
	@Override
	public BehaviorAlarmB stepTo(BehaviorAlarmB nextState, Application app){
		if(possibleNextStates(app).contains(nextState)){
			logger.info("Step from " + this.name() + " to " + nextState.name());
			return nextState;
		}else{
			logger.info("!!! Warning: Unable to step from " + this.name() + " to " + nextState.name() 
					+ " because the target state is not possible state.");
		}
		return this;
	}

}
