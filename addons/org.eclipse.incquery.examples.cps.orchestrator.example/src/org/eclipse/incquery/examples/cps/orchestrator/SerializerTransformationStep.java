package org.eclipse.incquery.examples.cps.orchestrator;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.xform.m2t.api.IM2TOutputProvider;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.incquery.examples.cps.xform.serializer.DefaultSerializer;
import org.eclipse.incquery.examples.cps.xform.serializer.javaio.JavaIOBasedFileAccessor;
import org.eclipse.viatra.emf.mwe2orchestrator.IListeningChannel;
import org.eclipse.viatra.emf.mwe2orchestrator.ITargetChannel;
import org.eclipse.viatra.emf.mwe2orchestrator.mwe2impl.MWE2TransformationStep;

public class SerializerTransformationStep extends MWE2TransformationStep {
    private static final String serializername = "SerializerChannel";
    private static final String chainEndName = "chainEndChannel";
    private static final String modifierName = "ModifierChannel";
    private boolean firstRun = true;
    public DefaultSerializer serializer;
    public String sourceFolder;
    public List<M2TOutputRecord> m2tOutput;
    
    @Override
    public void initialize(IWorkflowContext ctx) {
        this.context = ctx;
        System.out.println("Initialized serializer");
        serializer = new DefaultSerializer();
        sourceFolder = (String) ctx.get("folder");
        
    }

    public void execute() {
        processNextEvent();
        
        ListBasedOutputProvider provider = new ListBasedOutputProvider(m2tOutput);
        serializer.serialize(sourceFolder, provider, new JavaIOBasedFileAccessor());

        System.out.println("Serialization completed");
        
        if(firstRun){
            getModifierChannel().createEvent();
            firstRun = false;
        } else {          
            getChainEndChannel().createEvent();
        }

        
    }

    @Override
    public void dispose() {
        isRunning = false;
        System.out.println("Disposed serializer");
    }
    
    public IListeningChannel getSerializerChannel() {
        return getListeningChannel(serializername);
    }

    public void setSerializerChannel(IListeningChannel changeMonitorChannel) {
        changeMonitorChannel.setName(serializername);
        addListeningChannel(changeMonitorChannel);
    }

    public ITargetChannel getChainEndChannel() {
        return getTargetChannel(chainEndName);
    }

    public void setChainEndChannel(ITargetChannel chainend) {
        chainend.setName(chainEndName);
        addTargetChannel(chainend);
    }
    
    public ITargetChannel getModifierChannel() {
        return getTargetChannel(modifierName);
    }

    public void setModifierChannel(ITargetChannel chainend) {
        chainend.setName(modifierName);
        addTargetChannel(chainend);
    }
    
    public class ListBasedOutputProvider implements IM2TOutputProvider{
        private List<M2TOutputRecord> records = new ArrayList<M2TOutputRecord>();
        
        public ListBasedOutputProvider(List<M2TOutputRecord> records) {
            super();
            this.records = records;
        }
        
        @Override
        public List<M2TOutputRecord> getOutput() {
            return records;
        }
       
        public void setRecords(List<M2TOutputRecord> records) {
            this.records = records;
        }
    }

}
