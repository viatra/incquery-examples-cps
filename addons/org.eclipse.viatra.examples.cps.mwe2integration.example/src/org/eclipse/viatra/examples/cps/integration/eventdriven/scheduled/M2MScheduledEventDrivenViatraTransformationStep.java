package org.eclipse.viatra.examples.cps.integration.eventdriven.scheduled;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra;
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine;
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment;
import org.eclipse.viatra.integration.mwe2.eventdriven.mwe2impl.MWE2BaseControllableScheduler.MWEBaseControllableSchedulerFactory;
import org.eclipse.viatra.integration.mwe2.mwe2impl.TransformationStep;

public class M2MScheduledEventDrivenViatraTransformationStep extends TransformationStep {
    protected MWEBaseControllableSchedulerFactory factory;
    protected AdvancedViatraQueryEngine engine;
    protected CPS2DeploymentTransformationViatra transformation;

    @Override
    public void doInitialize(IWorkflowContext ctx) {
        CPSToDeployment cps2dep = (CPSToDeployment) ctx.get("model");
        engine = (AdvancedViatraQueryEngine) ctx.get("engine");
        factory = new MWEBaseControllableSchedulerFactory();
        transformation = new CPS2DeploymentTransformationViatra();
        transformation.setScheduler(factory);
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
        factory.run();
        while (!factory.isFinished()) {
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.println("Model-to-model transformation executed");
        
    }

}
