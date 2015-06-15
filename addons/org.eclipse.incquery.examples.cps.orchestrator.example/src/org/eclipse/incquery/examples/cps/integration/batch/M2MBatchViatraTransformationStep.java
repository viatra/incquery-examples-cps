package org.eclipse.incquery.examples.cps.integration.batch;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.CPS2DeploymentBatchViatra;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.viatra.emf.mwe2integration.IListeningChannel;
import org.eclipse.viatra.emf.mwe2integration.ITargetChannel;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.MWE2TransformationStep;

public class M2MBatchViatraTransformationStep extends MWE2TransformationStep {
    private static final String chainStartname = "chainStartChannel";
    private static final String m2mname = "M2MChannel";
    private static final String changemonitorname = "ChangeMonitorChannel";
    protected AdvancedIncQueryEngine engine;
    protected CPS2DeploymentBatchViatra transformation;

    @Override
    public void initialize(IWorkflowContext ctx) {
        this.context = ctx;
        CPSToDeployment cps2dep = (CPSToDeployment) ctx.get("model");
        
        engine = (AdvancedIncQueryEngine) ctx.get("engine");
        transformation = new CPS2DeploymentBatchViatra();
        transformation.initialize(cps2dep, engine);

        System.out.println("Initialized model-to-model transformation");
    }

    public void execute() {
        processNextEvent();

        transformation.execute();
        System.out.println("Model-to-model transformation executed");

        sendEventToAllTargets();
    }

    @Override
    public void dispose() {
        isRunning = false;
        transformation.dispose();
        System.out.println("Disposed model-to-model transformation");
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

}
