package org.eclipse.incquery.examples.cps.orchestrator.events;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.viatra.emf.mwe2orchestrator.IEventFactory;

public class M2TOutputEventFactory implements IEventFactory<List<M2TOutputRecord>, M2TOutputEvent> {

    @Override
    public M2TOutputEvent createEvent(Object parameter) {
        if(isValidParameter(parameter)){
            return new M2TOutputEvent((List<M2TOutputRecord>) parameter);
        }
        return new M2TOutputEvent(new ArrayList<M2TOutputRecord>()); 
    }

    @Override
    public M2TOutputEvent createEvent() {
        return createEvent("");
    }

    @Override
    public boolean isValidParameter(Object parameter) {
        try {
            List<M2TOutputRecord> list = ((List<M2TOutputRecord>)parameter);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

}
