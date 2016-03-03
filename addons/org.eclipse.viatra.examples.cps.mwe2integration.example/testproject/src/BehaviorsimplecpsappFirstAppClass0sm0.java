package testproject.hosts.statemachines;
	
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.Application;
import org.eclipse.viatra.examples.cps.m2t.proto.distributed.general.applications.statemachines.State;

import com.google.common.collect.Lists;

public enum BehaviorSimplecpsappfirstappclass0inst0 implements State<BehaviorSimplecpsappfirstappclass0inst0> {
	 ///////////
	// States
	Simplecpsappfirstappclass0sm0s1 {
	    @Override
	    public List<State<BehaviorSimplecpsappfirstappclass0inst0>> possibleNextStates(Application app) {
	    	List<State<BehaviorSimplecpsappfirstappclass0inst0>> possibleStates = Lists.newArrayList();
	    	
	    	// Add Neutral Transitions
	    	
	    	// Add Send Transitions
	    	
	    	// Add Wait Transitions
	    	
	    	return possibleStates;
	    }
	    
	}
	,Simplecpsappfirstappclass0sm0s0 {
	    @Override
	    public List<State<BehaviorSimplecpsappfirstappclass0inst0>> possibleNextStates(Application app) {
	    	List<State<BehaviorSimplecpsappfirstappclass0inst0>> possibleStates = Lists.newArrayList();
	    	
	    	// Add Neutral Transitions
	    	possibleStates.add(Simplecpsappfirstappclass0sm0s1);
	    	
	    	// Add Send Transitions
	    	
	    	// Add Wait Transitions
	    	
	    	return possibleStates;
	    }
	    
	}
	;
	
    private static Logger logger = Logger.getLogger("cps.proto.distributed.state");
    
	 /////////////////
	// General part
	@Override
	abstract public List<State<BehaviorSimplecpsappfirstappclass0inst0>> possibleNextStates(Application app);
	
	@Override
	public BehaviorSimplecpsappfirstappclass0inst0 stepTo(BehaviorSimplecpsappfirstappclass0inst0 nextState, Application app){
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
