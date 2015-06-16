package org.eclipse.incquery.examples.cps.integration.events;

import org.eclipse.viatra.emf.mwe2integration.IEventFactory;

public class EnablerEventFactory implements IEventFactory<Object, EnablerEvent> {

    @Override
    public EnablerEvent createEvent(Object parameter) {
        return createEvent();
    }

    @Override
    public EnablerEvent createEvent() {
        return new EnablerEvent("");
    }

    @Override
    public boolean isValidParameter(Object parameter) {
        return true;
    }

  

}
