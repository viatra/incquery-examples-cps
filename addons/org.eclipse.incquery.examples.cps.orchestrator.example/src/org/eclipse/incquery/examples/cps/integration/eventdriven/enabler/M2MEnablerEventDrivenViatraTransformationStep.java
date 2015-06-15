package org.eclipse.incquery.examples.cps.integration.eventdriven.enabler;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.incquery.runtime.emf.EMFScope;
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryEventRealm;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.viatra.emf.mwe2integration.IEvent;
import org.eclipse.viatra.emf.mwe2integration.IListeningChannel;
import org.eclipse.viatra.emf.mwe2integration.ITargetChannel;
import org.eclipse.viatra.emf.mwe2integration.eventdriven.mwe2impl.MWE2EnablerExecutor;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.MWE2ControlEvent;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.MWE2TransformationStep;

public class M2MEnablerEventDrivenViatraTransformationStep extends MWE2TransformationStep {
    private static final String chainStartname = "chainStartChannel";
    private static final String m2mname = "M2MChannel";
    private static final String changemonitorname = "ChangeMonitorChannel";
    private static final String enablingname = "EnablerChannel";
    private static final String disablingname = "DisablerChannel";
    private static final String selfdisablername = "DisablerChannel";

    protected MWE2EnablerExecutor executor;
    protected AdvancedIncQueryEngine engine;
    protected CPS2DeploymentTransformationViatra transformation;

    @Override
    public void initialize(IWorkflowContext ctx) {
        // create transformation
        System.out.println("Initialized model-to-model transformation");
        this.context = ctx;
        CPSToDeployment cps2dep = (CPSToDeployment) ctx.get("model");
        
        try {
            engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource().getResourceSet()));
            executor = new MWE2EnablerExecutor(IncQueryEventRealm.create(engine));
            ctx.put("engine", engine);
        } catch (IncQueryException e) {
            e.printStackTrace();
        }
        
       
        transformation = new CPS2DeploymentTransformationViatra();
        transformation.setExecutor(executor);
        transformation.initialize(cps2dep, engine);
        executor.enable();
    }

    public void execute() {
        IEvent<? extends Object> nextEvent = processNextEvent();
        if (nextEvent instanceof MWE2ControlEvent) {
            sendEventToAllTargets();
        }
    }

    @Override
    public void dispose() {
        isRunning = false;
        transformation.dispose();
        System.out.println("Disposed model-to-model transformation");
    }

    public void enable() {
        System.out.println("Fine grained M2M enabled");
        executor.enable();
    }

    public void disable() {
        System.out.println("Fine grained M2M disabled");
        executor.disable();
    }

    public IListeningChannel getChainStartChannel() {
        return getListeningChannel(chainStartname);
    }

    public void setChainStartChannel(IListeningChannel changeMonitorChannel) {
        changeMonitorChannel.setName(chainStartname);
        addListeningChannel(changeMonitorChannel);
    }

    public IListeningChannel getM2MChannel() {
        return getListeningChannel(m2mname);
    }

    public void setM2MChannel(IListeningChannel m2tChannel) {
        m2tChannel.setName(m2mname);
        addListeningChannel(m2tChannel);
    }

    public ITargetChannel getChangeMonitorChannel() {
        return getTargetChannel(changemonitorname);
    }

    public void setChangeMonitorChannel(ITargetChannel changeMonitorChannel) {
        changeMonitorChannel.setName(changemonitorname);
        addTargetChannel(changeMonitorChannel);
    }

    public IListeningChannel getEnablingChannel() {
        return getListeningChannel(enablingname);
    }

    public void setEnablingChannel(IListeningChannel enablingchannel) {
        enablingchannel.setName(enablingname);
        addListeningChannel(enablingchannel);
    }

    public IListeningChannel getDisablingChannel() {
        return getListeningChannel(disablingname);
    }

    public void setDisablingChannel(IListeningChannel m2tChannel) {
        m2tChannel.setName(disablingname);
        addListeningChannel(m2tChannel);
    }

    public ITargetChannel getSelfDisablerChannel() {
        return getTargetChannel(selfdisablername);
    }

    public void setSelfDisablerChannel(ITargetChannel changeMonitorChannel) {
        changeMonitorChannel.setName(selfdisablername);
        addTargetChannel(changeMonitorChannel);
    }

}
