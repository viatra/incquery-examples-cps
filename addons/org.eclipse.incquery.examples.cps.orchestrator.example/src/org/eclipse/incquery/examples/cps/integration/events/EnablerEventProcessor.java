package org.eclipse.incquery.examples.cps.integration.events;

import java.util.concurrent.BlockingQueue;

import org.eclipse.incquery.examples.cps.integration.eventdriven.enabler.M2MEnablerEventDrivenViatraTransformationStep;
import org.eclipse.viatra.emf.mwe2integration.IEvent;
import org.eclipse.viatra.emf.mwe2integration.IEventProcessor;
import org.eclipse.viatra.emf.mwe2integration.ITransformationStep;

public class EnablerEventProcessor implements IEventProcessor<Object, EnablerEvent>{
    private ITransformationStep parent;

    @Override
    public void processEvent(IEvent<? extends Object> nextEvent) {
        if(nextEvent instanceof EnablerEvent){
            if(parent instanceof M2MEnablerEventDrivenViatraTransformationStep){
                M2MEnablerEventDrivenViatraTransformationStep castParent = ((M2MEnablerEventDrivenViatraTransformationStep) parent);
                castParent.enable();
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
    public EnablerEvent getNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        IEvent<? extends Object> event = null;
        while(event == null && !events.isEmpty()){
            event = events.poll();
            if(event instanceof EnablerEvent){
                return (EnablerEvent) event;
            }
        }
        return null;
    }

    @Override
    public boolean hasNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        for (IEvent<? extends Object> event : events) {
            if(event instanceof EnablerEvent){
                return true;
            }
        }
        return false;
    }

}
