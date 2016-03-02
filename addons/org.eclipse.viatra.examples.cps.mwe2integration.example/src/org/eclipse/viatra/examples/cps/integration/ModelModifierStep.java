package org.eclipse.viatra.examples.cps.integration;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext;
import org.eclipse.viatra.examples.cps.generator.utils.CPSModelBuilderUtil;
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.ApplicationType;
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostInstance;
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.HostType;
import org.eclipse.viatra.examples.cps.traceability.CPSToDeployment;
import org.eclipse.viatra.integration.mwe2.mwe2impl.TransformationStep;

public class ModelModifierStep extends TransformationStep{
    protected CPSToDeployment model;
    protected CPSModelBuilderUtil modelBuilder = new CPSModelBuilderUtil();
    
    @Override
    public void doInitialize(IWorkflowContext ctx) {
        model = (CPSToDeployment) ctx.get("model");  
    }
    
    @Override
    public void doExecute() {
        modifyModel();
        System.out.println("Model modification executed");
        
    }
    
    @Override
    public void dispose() {
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
}
