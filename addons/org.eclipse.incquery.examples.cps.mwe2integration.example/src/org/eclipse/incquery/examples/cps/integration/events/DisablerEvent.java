package org.eclipse.incquery.examples.cps.integration.events;

import org.eclipse.viatra.emf.mwe2integration.IEvent;

public class DisablerEvent implements IEvent<Object> {
    private Object parameter;

    public DisablerEvent(Object parameter) {
        super();
        this.parameter = parameter;
    }
    
    @Override
    public Object getParameter() {
        return parameter;
    }
    
    @Override
    public void setParameter(Object parameter) {
        this.parameter = parameter;
    }
}
