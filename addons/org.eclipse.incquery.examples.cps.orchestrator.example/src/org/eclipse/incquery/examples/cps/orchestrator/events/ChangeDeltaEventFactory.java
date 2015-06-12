package org.eclipse.incquery.examples.cps.orchestrator.events;

import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.viatra.emf.mwe2orchestrator.IEventFactory;

public class ChangeDeltaEventFactory implements IEventFactory<DeploymentChangeDelta, ChangeDeltaEvent> {

    @Override
    public ChangeDeltaEvent createEvent(Object parameter) {
        if(isValidParameter(parameter)){
            return new ChangeDeltaEvent((DeploymentChangeDelta) parameter);
        }
        return null;
    }

    @Override
    public ChangeDeltaEvent createEvent() {
        return createEvent("");
    }

    @Override
    public boolean isValidParameter(Object parameter) {
        if(parameter instanceof DeploymentChangeDelta){
            return true;
        }
        return false;
    }

}
