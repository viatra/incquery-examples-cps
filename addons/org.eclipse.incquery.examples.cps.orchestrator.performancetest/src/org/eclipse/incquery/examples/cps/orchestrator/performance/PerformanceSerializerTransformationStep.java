package org.eclipse.incquery.examples.cps.orchestrator.performance;

import java.io.IOException;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.orchestrator.SerializerTransformationStep;
import org.eclipse.incquery.examples.cps.xform.serializer.DefaultSerializer;
import org.eclipse.incquery.examples.cps.xform.serializer.javaio.JavaIOBasedFileAccessor;

import eu.mondo.sam.core.metrics.MemoryMetric;
import eu.mondo.sam.core.metrics.TimeMetric;
import eu.mondo.sam.core.results.BenchmarkResult;
import eu.mondo.sam.core.results.PhaseResult;

public class PerformanceSerializerTransformationStep extends SerializerTransformationStep {  

    private boolean firstRun = true;
    
    @Override
    public void initialize(IWorkflowContext ctx) {
        this.context = ctx;
        System.out.println("Initialized serializer");
        serializer = new DefaultSerializer();
        sourceFolder = (String) ctx.get("folder"); 
    }

    public void execute() {
        processNextEvent();
        
        ////////////////////////////////////
        //////   Serialization phase
        ////////////////////////////////////
        
        //Mondo-sam metrics
        PhaseResult serializerResult = new PhaseResult();
        serializerResult.setPhaseName("Serialization");
        TimeMetric serializerTimer = new TimeMetric("Time");
        MemoryMetric serializerMemory = new MemoryMetric("Memory");

        serializerTimer.startMeasure();
        ListBasedOutputProvider provider = new ListBasedOutputProvider(m2tOutput);
        serializer.serialize(sourceFolder, provider, new JavaIOBasedFileAccessor());
        serializerTimer.stopMeasure();
        serializerMemory.measure();
        
        
        BenchmarkResult benchmarkResult = (BenchmarkResult) context.get("benchmarkresult");
        serializerResult.addMetrics(serializerTimer,serializerMemory);
        benchmarkResult.addResults(serializerResult);
        System.out.println("Serialization completed");
        
        if(firstRun){
            getModifierChannel().createEvent("");
            firstRun = false;
        } else {
            int i = 0;
            for (PhaseResult result : benchmarkResult.getPhaseResults()) {
                result.setSequence(i);
                i++;
            }
            try {
                benchmarkResult.publishResults();
            } catch (IOException e) {
                e.printStackTrace();
            }
            
            getChainEndChannel().createEvent(null);
        }

        
    }
}
