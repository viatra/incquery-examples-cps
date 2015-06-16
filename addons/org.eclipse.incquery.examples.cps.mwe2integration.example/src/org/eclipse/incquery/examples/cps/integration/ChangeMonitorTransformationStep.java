package org.eclipse.incquery.examples.cps.integration;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeMonitor;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.viatra.emf.mwe2integration.IListeningChannel;
import org.eclipse.viatra.emf.mwe2integration.ITargetChannel;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.MWE2TransformationStep;

public class ChangeMonitorTransformationStep extends MWE2TransformationStep {
    private static final String changemonitorname = "ChangeMonitorChannel";
    private static final String m2tname = "M2TChannel";
    
    protected AdvancedIncQueryEngine engine;
    protected DeploymentChangeMonitor monitor;

    
    @Override
    public void initialize(IWorkflowContext ctx) {
        // create transformation
        System.out.println("Initialized change monitor");
        this.context = ctx;
        engine = (AdvancedIncQueryEngine) ctx.get("engine");
        Deployment deployment = ((CPSToDeployment) ctx.get("model")).getDeployment();
        monitor = new DeploymentChangeMonitor(deployment, engine);
        try {
            monitor.startMonitoring();
        } catch (IncQueryException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void execute() {
        processNextEvent();
        DeploymentChangeDelta delta = monitor.createCheckpoint();
        System.out.println("Checkpoint created");
        sendEventToAllTargets(delta);
    }

    @Override
    public void dispose() {
        isRunning = false;
        System.out.println("Disposed change monitor");
    }
    
    public IListeningChannel getChangeMonitorChannel() {
        return getListeningChannel(changemonitorname);
    }

    public void setChangeMonitorChannel(IListeningChannel changeMonitorChannel) {
        changeMonitorChannel.setName(changemonitorname);
        addListeningChannel(changeMonitorChannel);
    }

    public ITargetChannel getM2TChannel() {
        return getTargetChannel(m2tname);
    }

    public void setM2TChannel(ITargetChannel m2tChannel) {
        m2tChannel.setName(m2tname);
        addTargetChannel(m2tChannel);
    }

}
