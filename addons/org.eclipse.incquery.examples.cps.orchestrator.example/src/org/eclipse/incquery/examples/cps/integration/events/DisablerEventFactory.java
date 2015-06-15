package org.eclipse.incquery.examples.cps.integration.events;

import org.eclipse.viatra.emf.mwe2integration.IEventFactory;

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
