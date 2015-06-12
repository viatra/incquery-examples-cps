package org.eclipse.incquery.examples.cps.orchestrator;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.ApplicationType;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostType;
import org.eclipse.incquery.examples.cps.generator.utils.CPSModelBuilderUtil;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.viatra.emf.mwe2orchestrator.IListeningChannel;
import org.eclipse.viatra.emf.mwe2orchestrator.ITargetChannel;
import org.eclipse.viatra.emf.mwe2orchestrator.mwe2impl.MWE2TransformationStep;

public class ModelModifierStep extends MWE2TransformationStep{
    private static final String chainEndName = "chainEndChannel";
    private static final String modifierName = "ModifierChannel";
    private static final String m2mname = "M2MChannel";
    
    protected CPSToDeployment model;
    protected CPSModelBuilderUtil modelBuilder = new CPSModelBuilderUtil();
    
    
    @Override
    public void initialize(IWorkflowContext ctx) {
        model = (CPSToDeployment) ctx.get("model");  
    }

    @Override
    public void execute() {
        processNextEvent();
        modifyModel();
        System.out.println("Model modification executed");
        sendEventToAllTargets();

    }

    @Override
    public void dispose() {
        isRunning = false;
        System.out.println("Disposed model modifier");
    }
    
    private void modifyModel(){
        ApplicationType appType = null;
        EList<ApplicationType> appTypes = model.getCps().getAppTypes();
//        if(!appTypes.isEmpty()){
//            appType = appTypes.get(0);
//        }
        for (ApplicationType applicationType : appTypes) {
            if(applicationType.getId().contains("AC_withStateMachine")){
                appType = applicationType;
            }
        }
        
        HostInstance instance = null;
        EList<HostType> hostTypes = model.getCps().getHostTypes();
//        if(!hostTypes.isEmpty() && !hostTypes.get(0).getInstances().isEmpty()){
//            instance = hostTypes.get(0).getInstances().get(0);
//        }
        for (HostType type : hostTypes) {
            if(type.getId().contains("HC_appContainer")){
                instance = type.getInstances().get(0);
            }
        }       
        if(appType != null && instance !=null){
            modelBuilder.prepareApplicationInstanceWithId(appType,"new.app.instance", instance);
        }
    }
    
    public ITargetChannel getChainEndChannel() {
        return getTargetChannel(chainEndName);
    }

    public void setChainEndChannel(ITargetChannel chainend) {
        chainend.setName(chainEndName);
        addTargetChannel(chainend);
    }
    
    public IListeningChannel getModifierChannel() {
        return getListeningChannel(modifierName);
    }

    public void setModifierChannel(IListeningChannel chainend) {
        chainend.setName(modifierName);
        addListeningChannel(chainend);
    }
    
    public ITargetChannel getM2MChannel() {
        return getTargetChannel(m2mname);
    }

    public void setM2MChannel(ITargetChannel m2tChannel) {
        m2tChannel.setName(m2mname);
        addTargetChannel(m2tChannel);
    }

}
