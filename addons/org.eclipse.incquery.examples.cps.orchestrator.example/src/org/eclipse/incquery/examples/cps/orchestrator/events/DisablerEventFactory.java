package org.eclipse.incquery.examples.cps.orchestrator.events;

import org.eclipse.viatra.emf.mwe2orchestrator.IEventFactory;

public class DisablerEventFactory implements IEventFactory<Object, DisablerEvent> {

    @Override
    public DisablerEvent createEvent(Object parameter) {
        return createEvent();
    }

    @Override
    public DisablerEvent createEvent() {
        return new DisablerEvent("");
    }

    @Override
    public boolean isValidParameter(Object parameter) {
        return true;
    }



}
