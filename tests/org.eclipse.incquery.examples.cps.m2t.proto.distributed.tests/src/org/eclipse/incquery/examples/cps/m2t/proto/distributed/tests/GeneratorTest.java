package org.eclipse.incquery.examples.cps.m2t.proto.distributed.tests;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication;
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.examples.cps.deployment.DeploymentPackage;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.Generator;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.api.ICPSGenerator;
import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.exceptions.CPSGeneratorException;
import org.eclipse.incquery.examples.cps.tests.CPSTestBase;
import org.junit.Test;

public class GeneratorTest extends CPSTestBase {

	private static Logger logger = Logger.getLogger("cps.proto.generator");
	
	@Test
	public void test(){
		logger.info("Start Generating...");
		
		Deployment model = loadModel("C:\\Eclipses\\CPSDemonstrator\\git\\incquery-examples-cps\\models\\org.eclipse.incquery.examples.cps.instances\\example.deployment");
		
		ICPSGenerator generator = new Generator("org.alma");
		try{
			for(DeploymentHost host : model.getHosts()){
				logger.info(generator.generateHostCode(host));
				logger.info("********* A P P L I C A T I O N S *********");
				for(DeploymentApplication app : host.getApplications()){
					logger.info(generator.generateApplicationCode(app));
						logger.info("********* B E H A V I O R *********");
						logger.info(generator.generateBehaviorCode(app.getBehavior()));
						logger.info("");
					logger.info("");
					logger.info("*************************************");
					logger.info("*******************************************");
					
				}
				logger.info("");
			}
		}catch(CPSGeneratorException e){
			e.printStackTrace();
			fail();
		}
		
		assertTrue(true);
	}

	public Deployment loadModel(String filePath) {
	    // Initialize the model
		DeploymentPackage.eINSTANCE.eClass();
	    
	    // Register the XMI resource factory for the .website extension

	    Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
	    Map<String, Object> m = reg.getExtensionToFactoryMap();
	    m.put("website", new XMIResourceFactoryImpl());

	    // Obtain a new resource set
	    ResourceSet resSet = new ResourceSetImpl();

	    // Get the resource
	    Resource resource = resSet.getResource(URI.createFileURI(filePath), true);
	    // Get the first model element and cast it to the right type, in my
	    // example everything is hierarchical included in this first node
	    if(!resource.getContents().isEmpty() && resource.getContents().get(0) instanceof Deployment){
	    	return (Deployment) resource.getContents().get(0);
	    }
	    return null;
	  }
}
