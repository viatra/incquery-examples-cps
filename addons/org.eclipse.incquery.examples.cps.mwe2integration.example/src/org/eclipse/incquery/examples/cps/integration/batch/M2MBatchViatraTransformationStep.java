package org.eclipse.incquery.examples.cps.integration.batch;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.incquery.examples.cps.xform.m2m.batch.viatra.CPS2DeploymentBatchViatra;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.TransformationStep;

public class M2MBatchViatraTransformationStep extends TransformationStep {
    protected AdvancedIncQueryEngine engine;
    protected CPS2DeploymentBatchViatra transformation;

    @Override
    public void doInitialize(IWorkflowContext ctx) {
        CPSToDeployment cps2dep = (CPSToDeployment) ctx.get("model");
        
        engine = (AdvancedIncQueryEngine) ctx.get("engine");
        transformation = new CPS2DeploymentBatchViatra();
        transformation.initialize(cps2dep, engine);

        System.out.println("Initialized model-to-model transformation");
    }   

    @Override
    public void doExecute() {
        transformation.execute();
        System.out.println("Model-to-model transformation executed");
    }

    @Override
    public void dispose() {
        transformation.dispose();
        System.out.println("Disposed model-to-model transformation");
    }
}
