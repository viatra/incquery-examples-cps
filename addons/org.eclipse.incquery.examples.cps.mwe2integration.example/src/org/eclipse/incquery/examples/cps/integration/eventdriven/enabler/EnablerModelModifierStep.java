package org.eclipse.incquery.examples.cps.integration.eventdriven.enabler;

import org.eclipse.incquery.examples.cps.integration.ModelModifierStep;
import org.eclipse.viatra.emf.mwe2integration.ITargetChannel;

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
