package org.eclipse.incquery.examples.cps.xform.m2m.util

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost

class NamingUtil {
	
	static def name(HostInstance cpsHost) {
		cpsHost.nodeIp
	}
	
	static def name(Identifiable cpsIdentifiable) {
		cpsIdentifiable.id
	}
	
	static def name(DeploymentHost depHost) {
		depHost.ip
	}
	
	static def name(DeploymentApplication depApplication) {
		depApplication.id
	}
	
	static def name(DeploymentElement depElement) {
		depElement.description
	}
}