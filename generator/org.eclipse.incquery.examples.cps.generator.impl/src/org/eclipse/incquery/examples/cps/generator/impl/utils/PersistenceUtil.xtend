package org.eclipse.incquery.examples.cps.generator.impl.utils

import java.io.IOException
import java.util.Collections
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage

class PersistenceUtil {
	
	def static saveCPSModelToFile(CyberPhysicalSystem modelRoot, String path){
		// Initialize the model
	    CyberPhysicalSystemPackage.eINSTANCE.eClass();
	    // Retrieve the default factory singleton
	
	    // Obtain a new resource set
	    val ResourceSet resSet = new ResourceSetImpl();
	
	    // create a resource
	    val Resource resource = resSet.createResource(URI.createFileURI(path));
	    resource.getContents().add(modelRoot);
	
	    // now save the content.
	    try {
	      resource.save(Collections.EMPTY_MAP);
	    } catch (IOException e) {
	      e.printStackTrace();
	    }
	}
	
}