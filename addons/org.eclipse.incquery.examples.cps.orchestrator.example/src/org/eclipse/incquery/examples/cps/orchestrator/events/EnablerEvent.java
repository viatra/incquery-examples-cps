package org.eclipse.incquery.examples.cps.orchestrator.events;

import org.eclipse.viatra.emf.mwe2orchestrator.IEvent;

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
