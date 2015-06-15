package org.eclipse.incquery.examples.cps.integration;

import java.util.List;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.xform.m2t.api.ChangeM2TOutputProvider;
import org.eclipse.incquery.examples.cps.xform.m2t.api.ICPSGenerator;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.CodeGenerator;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.viatra.emf.mwe2integration.IListeningChannel;
import org.eclipse.viatra.emf.mwe2integration.ITargetChannel;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.MWE2TransformationStep;

public class M2TDistributedTransformationStep extends MWE2TransformationStep {
    private static final String serializername = "SerializerChannel";
    private static final String m2tname = "M2TChannel";
    protected AdvancedIncQueryEngine engine;
    public ICPSGenerator generator;
    public String projectName;
    public String sourceFolder;
    public List<M2TOutputRecord> output;
    public DeploymentChangeDelta delta;
   
    
    @Override
    public void initialize(IWorkflowContext ctx) {
        System.out.println("Initialized model-to-text transformation");
        this.context = ctx;
        engine = (AdvancedIncQueryEngine) ctx.get("engine");
        projectName = (String) ctx.get("projectname");
        sourceFolder = (String) ctx.get("folder");
        generator = new CodeGenerator(projectName,engine,true);
        
    }

    @Override
    public void execute() {
        processNextEvent();
        
        ChangeM2TOutputProvider provider = new ChangeM2TOutputProvider(delta, generator, sourceFolder);
        output = provider.generateChanges();
        
        System.out.println("Model-to-text transformation executed");
        sendEventToAllTargets(output);
    }

    @Override
    public void dispose() {
        isRunning = false;
        System.out.println("Disposed model-to-text transformation");

    }
    
    public IListeningChannel getM2TChannel() {
        return getListeningChannel(m2tname);
    }

    public void setM2TChannel(IListeningChannel changeMonitorChannel) {
        changeMonitorChannel.setName(m2tname);
        addListeningChannel(changeMonitorChannel);
    }

    public ITargetChannel getSerializerChannel() {
        return getTargetChannel(serializername);
    }

    public void setSerializerChannel(ITargetChannel m2tChannel) {
        m2tChannel.setName(serializername);
        addTargetChannel(m2tChannel);
    }

}
