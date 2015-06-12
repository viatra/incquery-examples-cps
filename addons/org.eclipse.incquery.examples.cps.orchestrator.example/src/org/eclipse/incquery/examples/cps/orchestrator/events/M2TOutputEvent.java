package org.eclipse.incquery.examples.cps.orchestrator.events;

import java.util.List;

import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.viatra.emf.mwe2orchestrator.IEvent;

public class M2TOutputEvent implements IEvent<List<M2TOutputRecord>> {
    private List<M2TOutputRecord> parameter;

    public M2TOutputEvent(List<M2TOutputRecord> parameter) {
        super();
        this.parameter = parameter;
    }
    
    public List<M2TOutputRecord> getParameter() {
        return parameter;
    }

    public void setParameter(List<M2TOutputRecord> parameter) {
        this.parameter = parameter;
    }

}
