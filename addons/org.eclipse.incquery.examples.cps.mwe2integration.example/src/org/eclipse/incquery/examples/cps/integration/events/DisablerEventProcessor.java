package org.eclipse.incquery.examples.cps.integration.events;

import java.util.concurrent.BlockingQueue;

import org.eclipse.incquery.examples.cps.integration.eventdriven.enabler.M2MEnablerEventDrivenViatraTransformationStep;
import org.eclipse.viatra.emf.mwe2integration.IEvent;
import org.eclipse.viatra.emf.mwe2integration.IEventProcessor;
import org.eclipse.viatra.emf.mwe2integration.ITransformationStep;

public class DisablerEventProcessor implements IEventProcessor<Object, DisablerEvent>{
    private ITransformationStep parent;
    
    
    @Override
    public void processEvent(IEvent<? extends Object> nextEvent) {
        if(nextEvent instanceof DisablerEvent){
            if(parent instanceof M2MEnablerEventDrivenViatraTransformationStep){
                M2MEnablerEventDrivenViatraTransformationStep castParent = ((M2MEnablerEventDrivenViatraTransformationStep) parent);
                castParent.disable();
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
    public DisablerEvent getNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        IEvent<? extends Object> event = null;
        while(event == null && !events.isEmpty()){
            event = events.poll();
            if(event instanceof DisablerEvent){
                return (DisablerEvent) event;
            }
        }
        return null;
    }

    @Override
    public boolean hasNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        for (IEvent<? extends Object> event : events) {
            if(event instanceof DisablerEvent){
                return true;
            }
        }
        return false;
    }


}
