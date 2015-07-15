package org.eclipse.incquery.examples.cps.integration;

import java.util.List;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.xform.m2t.api.ChangeM2TOutputProvider;
import org.eclipse.incquery.examples.cps.xform.m2t.api.ICPSGenerator;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.viatra.emf.mwe2integration.IPublishTo;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.TransformationStep;

public class M2TDistributedTransformationStep extends TransformationStep {
    protected AdvancedIncQueryEngine engine;
    public ICPSGenerator generator;
    public String projectName;
    public String sourceFolder;
    public List<M2TOutputRecord> output;
    public DeploymentChangeDelta delta;
   
    
    @Override
    public void doInitialize(IWorkflowContext ctx) {
        System.out.println("Initialized model-to-text transformation");
        engine = (AdvancedIncQueryEngine) ctx.get("engine");
        projectName = (String) ctx.get("projectname");
        sourceFolder = (String) ctx.get("folder");
        generator = new CodeGenerator(projectName,engine,true);
        
    }
    
    @Override
    public void doExecute() {
        ChangeM2TOutputProvider provider = new ChangeM2TOutputProvider(delta, generator, sourceFolder);
        output = provider.generateChanges();
        System.out.println("Model-to-text transformation executed");
    }
    
    @Override
    public void publishMessages() {
        for (IPublishTo iPublishTo : publishTo) {
            iPublishTo.publishMessage(output);
        }
    }
    
    @Override
    public void dispose() {
        System.out.println("Disposed model-to-text transformation");

    }
}
