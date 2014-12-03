package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator

import com.google.common.collect.ImmutableList
import java.util.HashMap
import org.apache.log4j.Logger
import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.deployment.DeploymentPackage
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.exceptions.CPSGeneratorException
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.utils.GeneratorHelper
import org.eclipse.incquery.runtime.base.api.IncQueryBaseFactory
import com.google.common.collect.Lists
import com.google.common.base.Joiner

class Generator implements ICPSGenerator  {
	
	private extension Logger logger = Logger.getLogger("cps.codegenerator")
	
	private extension GeneratorHelper helper = new GeneratorHelper
	val String PROJECT_NAME // = "org.eclipse.incquery.examples.cps.m2t.proto.distributed.generated"
	
	new(String projectName){
		PROJECT_NAME = projectName
	}
	
	override generateHostCode(DeploymentHost host) '''
	package «PROJECT_NAME».hosts;

	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.communicationlayer.CommunicationNetwork;
	import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.BaseHost;
	import com.google.common.collect.Lists;
	«FOR app : host.applications»
	import «PROJECT_NAME».applications.«app.id.purifyAndToUpperCamel»Application;
	«ENDFOR»

	
	public class Host«host.ip.purifyAndToUpperCamel» extends BaseHost {
		
		public Host«host.ip.purifyAndToUpperCamel»(CommunicationNetwork network) {
			super(network);
			// Add Applications of Host
			applications = Lists.<Application>newArrayList(
			«Joiner.on(',').join(host.calculateAppListForHost)»
			);
		}
	
	} 
	'''
	
	def calculateAppListForHost(DeploymentHost host){
		val list = Lists.<CharSequence>newArrayList;
		for(app : host.applications){
			list.add('''new «app.id.purifyAndToUpperCamel»Application(this)''')
		}
		list
	}
	
	override generateApplicationCode(DeploymentApplication app)'''
		«val behavior = "Behavior"+app.id.purifyAndToUpperCamel»
		«val appClassName = app.id.purifyAndToUpperCamel + "Application"»
		package «PROJECT_NAME».applications;
	
		import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.BaseApplication;
		import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.Host;
		
		import «PROJECT_NAME».hosts.statemachines.«behavior»;
		
		
		public class «appClassName» extends BaseApplication<«behavior»> {
		
			// Set ApplicationID
			protected static final String APP_ID = "«app.id»";
		
			public «appClassName»(Host host) {
				super(host);
				
				// Set initial State
				currentState = «behavior».«app.behavior.current.description.purifyAndToUpperCamel»;
			}
			
			@Override
			public String getAppID() {
				return APP_ID;
			}
			
		}
	'''
	
	override generateBehaviorCode(DeploymentBehavior behavior)'''
		«val app = behavior.eContainer as DeploymentApplication»
		«val behaviorClassName = "Behavior"+app.id.purifyAndToUpperCamel»
		package «PROJECT_NAME».hosts.statemachines;
	
		import java.util.List;
		
		import org.apache.log4j.Logger;
		import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application;
		import org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.statemachines.State;
		
		import com.google.common.collect.Lists;
		
		public enum «behaviorClassName» implements State<«behaviorClassName»> {
			 ///////////
			// States
			«Joiner.on(',').join(behavior.calculateStateCodeListFor(behaviorClassName))»;
			
		    private static Logger logger = Logger.getLogger("cps.proto.distributed.state");
		    
			 /////////////////
			// General part
			@Override
			abstract public List<State<«behaviorClassName»>> possibleNextStates(Application app);
			
			@Override
			public «behaviorClassName» stepTo(«behaviorClassName» nextState, Application app){
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
	'''
	
	def calculateStateCodeListFor(DeploymentBehavior behavior, String behaviorClassName){
		val list = Lists.<CharSequence>newArrayList
		for(state : behavior.states){
			list.add(generateState(state, behaviorClassName))
		}
		list
	}
	
	def generateState(BehaviorState state, String behaviorClassName) '''
		«state.description.purifyAndToUpperCamel» {
		    @Override
		    public List<State<«behaviorClassName»>> possibleNextStates(Application app) {
		    	List<State<«behaviorClassName»>> possibleStates = Lists.newArrayList();
		    	
		    	// Add Neutral Transitions
		    	«FOR trgState : state.calculateNeutralStateTransition»
		    	possibleStates.add(«trgState.description.purifyAndToUpperCamel»);
		    	«ENDFOR»
		    	
		    	// Add Send Transitions
		    	«FOR trgState : state.calculateSendStateTransition»
		    	possibleStates.add(«trgState.description.purifyAndToUpperCamel»);
		    	«ENDFOR»
		    	
		    	// Add Wait Transitions
		    	«val map = state.calculateWaitStateTransition»
		    	«FOR trgTransition : map.keySet»
		    	if(app.hasMessageFor("«trgTransition.description.purifyAndToUpperCamel»")){
		    		possibleStates.add(«map.get(trgTransition).description.purifyAndToUpperCamel»);
		    	}
				«ENDFOR»
		    	
		    	return possibleStates;
		    }
		    
		    «IF state.hasSendTrigger»
		    @Override
		    public «behaviorClassName» stepTo(«behaviorClassName» nextState, Application app) {
		    	// Send triggers
		    	«FOR trgState : state.calculateSendStateTransition»
		    	if(nextState == «trgState.description.purifyAndToUpperCamel»){
		    		app.sendTrigger(«state.calculateSendTriggerParameters(trgState)»);
		    		return super.stepTo(nextState, app);
		    	}
		    	«ENDFOR»
		    	// Other cases (wait, neutral)
		    	return super.stepTo(nextState, app);
		    }
		    «ENDIF»
		}
	'''
	
	def String calculateSendTriggerParameters(BehaviorState srcState, BehaviorState trgState){
		//"152.66.102.5", "IBM System Storage", "ISSReceiving"
		val transition = srcState.outgoing.findFirst[transition | transition.to == trgState]
		if(transition != null){
			'''"«transition.trigger.head.host.ip»", "«transition.trigger.head.app.id»", "«transition.trigger.head.name»"'''
		}else{
			throw new CPSGeneratorException("#Error: Cannot find transition from " + srcState.name + " to " + trgState.name)
		}
	}
	
	def DeploymentApplication app(BehaviorTransition transition){
		val app = transition?.eContainer?.eContainer
		if(app != null && app instanceof DeploymentApplication){
			return app as DeploymentApplication
		}
		throw new CPSGeneratorException("#Error: Cannot find Application of the Transition (" + transition.name + ")")
	}
	
	def DeploymentHost host(BehaviorTransition transition){
		val app = transition?.eContainer?.eContainer?.eContainer
		if(app != null && app instanceof DeploymentHost){
			return app as DeploymentHost
		}
		throw new CPSGeneratorException("#Error: Cannot find Host of the Transition (" + transition.name + ")")
	}
	
	def DeploymentApplication app(BehaviorState state){
		val app = state?.eContainer?.eContainer
		if(app != null && app instanceof DeploymentApplication){
			return app as DeploymentApplication
		}
		throw new CPSGeneratorException("#Error: Cannot find Application of the State (" + state.name + ")")
	}
	
	def DeploymentHost host(BehaviorState state){
		val host = state?.eContainer?.eContainer?.eContainer
		if(host != null && host instanceof DeploymentHost){
			return host as DeploymentHost
		}
		throw new CPSGeneratorException("#Error: Cannot find Host of the State (" + state.name + ")")
	}
	
	def String name(BehaviorState state){
		state.description.purifyAndToUpperCamel
	}
	
	def String name(BehaviorTransition transition){
		transition.description.purifyAndToUpperCamel
	}
	
	def boolean hasSendTrigger(BehaviorState srcState){
		return srcState.outgoing.exists[ transition | !transition.trigger.empty]
	}
	
	def Iterable<BehaviorState> calculateSendStateTransition(BehaviorState srcState){
		srcState.outgoing.filter[transition | 
	        		return !transition.trigger.empty
	    ].map[transition | transition.to]
	}
	
	def calculateWaitStateTransition(BehaviorState srcState){
		// TODO optimize
		val baseIndex = IncQueryBaseFactory.getInstance.createNavigationHelper(srcState.eResource.resourceSet, true, logger)
		val waitTransitions = srcState.outgoing.filter[transition | 
	        		val incomingTrigger = baseIndex.getInverseReferences(transition, ImmutableList.of(DeploymentPackage.Literals.BEHAVIOR_TRANSITION__TRIGGER))
	        		return transition.trigger.empty && !incomingTrigger.empty
	    ]
	    val map = new HashMap<BehaviorTransition, BehaviorState>
	    
	    waitTransitions.forEach[waitTrans | 
	    	map.put(waitTrans, waitTrans.to)
	    ]
	    
	    return map
	}
	
	def Iterable<BehaviorState> calculateNeutralStateTransition(BehaviorState srcState){
		// TODO optimize
		val incomingTrigger = IncQueryBaseFactory.getInstance.createNavigationHelper(srcState.eResource.resourceSet, true, Logger.getLogger("cps.codegenerator"))
		srcState.outgoing.filter[transition | 
	        		val reverse = incomingTrigger.getInverseReferences(transition, ImmutableList.of(DeploymentPackage.Literals.BEHAVIOR_TRANSITION__TRIGGER))
	        		return transition.trigger.empty && reverse.empty
	    ].map[transition | transition.to]
	}
	
	override generateDeploymentCode(Deployment deployment) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
	
}