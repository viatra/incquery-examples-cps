package org.eclipse.incquery.examples.cps.integration.events;

import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.viatra.emf.mwe2integration.IEvent;

public class ChangeDeltaEvent implements IEvent<DeploymentChangeDelta> {
    private DeploymentChangeDelta parameter;

    public ChangeDeltaEvent(DeploymentChangeDelta parameter) {
        super();
        this.parameter = parameter;
    }
    
    public DeploymentChangeDelta getParameter() {
        return parameter;
    }

    public void setParameter(DeploymentChangeDelta parameter) {
        this.parameter = parameter;
    }
}
