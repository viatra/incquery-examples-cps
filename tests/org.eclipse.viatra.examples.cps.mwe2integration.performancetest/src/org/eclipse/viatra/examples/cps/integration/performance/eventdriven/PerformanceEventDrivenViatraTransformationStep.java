package org.eclipse.viatra.examples.cps.integration.performance.eventdriven;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.viatra.examples.cps.integration.eventdriven.controllable.M2MControllableEventDrivenViatraTransformationStep;
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment;
import org.eclipse.viatra.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra;
import org.eclipse.viatra.integration.mwe2.eventdriven.mwe2impl.MWE2ControlledExecutor;
import org.eclipse.viatra.query.runtime.api.AdvancedViatraQueryEngine;
import org.eclipse.viatra.query.runtime.emf.EMFScope;
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException;
import org.eclipse.viatra.transformation.evm.specific.event.ViatraQueryEventRealm;

import eu.mondo.sam.core.metrics.MemoryMetric;
import eu.mondo.sam.core.metrics.TimeMetric;
import eu.mondo.sam.core.results.BenchmarkResult;
import eu.mondo.sam.core.results.PhaseResult;

public class PerformanceEventDrivenViatraTransformationStep extends M2MControllableEventDrivenViatraTransformationStep {
    @Override
    public void initialize(IWorkflowContext ctx) {

        this.context = ctx;
        CPSToDeployment cps2dep = (CPSToDeployment) ctx.get("model");
        BenchmarkResult benchmarkResult = (BenchmarkResult) ctx.get("benchmarkresult");
        
        ////////////////////////////////////
        //////   Transformation initialization phase
        ////////////////////////////////////
        
        PhaseResult initResult = new PhaseResult();
        initResult.setPhaseName("Initialization");
        TimeMetric initTimer = new TimeMetric("Time");
        
        initTimer.startMeasure();	
        try {
            engine = AdvancedViatraQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource().getResourceSet()));
            executor = new MWE2ControlledExecutor(ViatraQueryEventRealm.create(engine));
            transformation = new CPS2DeploymentTransformationViatra();
            transformation.setExecutor(executor);
            transformation.initialize(cps2dep,engine);
        } catch (ViatraQueryException e) {
            e.printStackTrace();
        }
        initTimer.stopMeasure();
        initResult.addMetrics(initTimer);
        benchmarkResult.addResults(initResult);
        
        ctx.put("engine", engine);
        System.out.println("Initialized model-to-model transformation");
 
    }

    public void doEexecute() {
        BenchmarkResult benchmarkResult = (BenchmarkResult) context.get("benchmarkresult");
        
        ////////////////////////////////////
        //////  MTM Transformation phase
        ////////////////////////////////////
        
        PhaseResult mtmResult = new PhaseResult();
        mtmResult.setPhaseName("M2MTransformation");
        TimeMetric mtmTimer = new TimeMetric("Time");
        MemoryMetric mtmMemory = new MemoryMetric("Memory");
        
        mtmTimer.startMeasure();
        executor.run();
     
        while(!executor.isFinished()){
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        mtmTimer.stopMeasure();
        mtmMemory.measure();
        
        mtmResult.addMetrics(mtmTimer,mtmMemory);
        benchmarkResult.addResults(mtmResult);
        System.out.println("Model-to-model transformation executed");
    }
}
