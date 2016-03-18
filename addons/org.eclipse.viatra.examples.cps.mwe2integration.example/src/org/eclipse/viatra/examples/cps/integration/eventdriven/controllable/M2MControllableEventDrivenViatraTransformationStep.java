package org.eclipse.viatra.examples.cps.integration.eventdriven.controllable;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment;
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra;
import org.eclipse.viatra.integration.mwe2.eventdriven.mwe2impl.MWE2ControlledExecutor;
import org.eclipse.viatra.integration.mwe2.mwe2impl.TransformationStep;
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine;
import org.eclipse.viatra.transformation.evm.specific.event.ViatraQueryEventRealm;

public class M2MControllableEventDrivenViatraTransformationStep extends TransformationStep {
    protected MWE2ControlledExecutor executor;
    protected AdvancedViatraQueryEngine engine;
    protected CPS2DeploymentTransformationViatra transformation;

    @Override
    public void doInitialize(IWorkflowContext ctx) {
        // create transformation
        CPSToDeployment cps2dep = (CPSToDeployment) ctx.get("model");
        engine = (AdvancedViatraQueryEngine) ctx.get("engine");
        executor = new MWE2ControlledExecutor(ViatraQueryEventRealm.create(engine));
        transformation = new CPS2DeploymentTransformationViatra();
        transformation.setExecutor(executor);
        transformation.initialize(cps2dep, engine);
        System.out.println("Initialized model-to-model transformation");

    }

    @Override
    public void dispose() {
        transformation.dispose();
        System.out.println("Disposed model-to-model transformation");
    }

    @Override
    public void doExecute() {
        executor.run();
        while (!executor.isFinished()) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("Model-to-model transformation executed");

    }

}
