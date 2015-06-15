package org.eclipse.incquery.examples.cps.integration.events;

import org.eclipse.viatra.emf.mwe2integration.IEvent;

public class EnablerEvent implements IEvent<Object> {
    private Object parameter;

    public EnablerEvent(Object parameter) {
        super();
        this.parameter = parameter;
    }
    
    public Object getParameter() {
        return parameter;
    }

    public void setParameter(Object parameter) {
        this.parameter = parameter;
    }
}
