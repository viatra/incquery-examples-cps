package org.eclipse.incquery.examples.cps.integration.performance.eventdriven;

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.integration.eventdriven.controllable.M2MControllableEventDrivenViatraTransformationStep;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.incquery.examples.cps.xform.m2m.incr.viatra.CPS2DeploymentTransformationViatra;
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine;
import org.eclipse.incquery.runtime.emf.EMFScope;
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryEventRealm;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.viatra.emf.mwe2integration.eventdriven.mwe2impl.MWE2ControllableExecutor;

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
            engine = AdvancedIncQueryEngine.createUnmanagedEngine(new EMFScope(cps2dep.eResource().getResourceSet()));
            executor = new MWE2ControllableExecutor(IncQueryEventRealm.create(engine));
            transformation = new CPS2DeploymentTransformationViatra();
            transformation.setExecutor(executor);
            transformation.initialize(cps2dep,engine);
        } catch (IncQueryException e) {
            e.printStackTrace();
        }
        initTimer.stopMeasure();
        initResult.addMetrics(initTimer);
        benchmarkResult.addResults(initResult);
        
        ctx.put("engine", engine);
        System.out.println("Initialized model-to-model transformation");
 
    }

    public void execute() {
        processNextEvent();
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
        sendEventToAllTargets();
    }
}
