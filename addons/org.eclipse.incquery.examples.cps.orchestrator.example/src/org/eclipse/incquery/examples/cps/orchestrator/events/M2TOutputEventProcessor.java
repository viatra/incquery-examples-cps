package org.eclipse.incquery.examples.cps.orchestrator.events;

import java.util.List;
import java.util.concurrent.BlockingQueue;

import org.eclipse.incquery.examples.cps.orchestrator.SerializerTransformationStep;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.viatra.emf.mwe2orchestrator.IEvent;
import org.eclipse.viatra.emf.mwe2orchestrator.IEventProcessor;
import org.eclipse.viatra.emf.mwe2orchestrator.ITransformationStep;

public class M2TOutputEventProcessor implements IEventProcessor<List<M2TOutputRecord>,M2TOutputEvent>{
    private ITransformationStep parent;

    @Override
    public void processEvent(IEvent<? extends Object> nextEvent) {
        if(nextEvent instanceof M2TOutputEvent){
            M2TOutputEvent event = ((M2TOutputEvent) nextEvent);
            if(parent instanceof SerializerTransformationStep){
                SerializerTransformationStep serializerparent = ((SerializerTransformationStep) parent);
                serializerparent.m2tOutput = event.getParameter();
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
    public M2TOutputEvent getNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        IEvent<? extends Object> event = null;
        while(event == null && !events.isEmpty()){
            event = events.poll();
            if(event instanceof M2TOutputEvent){
                return (M2TOutputEvent) event;
            }
        }
        return null;
    }

    @Override
    public boolean hasNextEvent(BlockingQueue<? extends IEvent<? extends Object>> events) {
        for (IEvent<? extends Object> event : events) {
            if(event instanceof M2TOutputEvent){
                return true;
            }
        }
        return false;
    }




}
