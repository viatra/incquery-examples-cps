package org.eclipse.incquery.examples.cps.orchestrator.eventdriven.enabler;

import org.eclipse.incquery.examples.cps.orchestrator.ModelModifierStep;
import org.eclipse.viatra.emf.mwe2orchestrator.ITargetChannel;

public class EnablerModelModifierStep extends ModelModifierStep{
    private static final String enablerName = "EnablerChannel";

    public ITargetChannel getEnablerChannel() {
        return getTargetChannel(enablerName);
    }

    public void setEnablerChannel(ITargetChannel m2tChannel) {
        m2tChannel.setName(enablerName);
        addTargetChannel(m2tChannel);
    }

}
