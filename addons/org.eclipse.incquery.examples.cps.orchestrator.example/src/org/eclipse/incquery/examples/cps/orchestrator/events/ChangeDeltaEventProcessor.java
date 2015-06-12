package org.eclipse.incquery.examples.cps.orchestrator.events;

import java.util.concurrent.BlockingQueue;

import org.eclipse.incquery.examples.cps.orchestrator.M2TDistributedTransformationStep;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.viatra.emf.mwe2orchestrator.IEvent;
import org.eclipse.viatra.emf.mwe2orchestrator.IEventProcessor;
import org.eclipse.viatra.emf.mwe2orchestrator.ITransformationStep;


public class ChangeDeltaEventProcessor implements IEventProcessor<DeploymentChangeDelta, ChangeDeltaEvent>{
    protected ITransformationStep parent;
    
    @Override
    public void processEvent(IEvent<? extends Object> nextEvent) {
        if(nextEvent instanceof ChangeDeltaEvent){
            ChangeDeltaEvent event = ((ChangeDeltaEvent) nextEvent);
            if(parent instanceof M2TDistributedTransformationStep){
                M2TDistributedTransformationStep m2tparent = ((M2TDistributedTransformationStep) parent);
                m2tparent.delta = event.getParameter();
            } 
        } 
    }

    @Override
    public ITransformationStep getParent() {
        return parent;
    }

    @Override
    public void setParent(ITransformationStep parent) {
        this.parent = parent;
        
    }

    @Override
    public ChangeDeltaEvent getNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        IEvent<? extends Object> event = null;
        while(event == null && !events.isEmpty()){
            event = events.poll();
            if(event instanceof ChangeDeltaEvent){
                return (ChangeDeltaEvent) event;
            }
        }
        return null;
    }

    @Override
    public boolean hasNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        for (IEvent<? extends Object> event : events) {
            if(event instanceof ChangeDeltaEvent){
                return true;
            }
        }
        return false;
    }

}
