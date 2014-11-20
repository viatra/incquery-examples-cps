package org.eclipse.incquery.examples.cps.xform.m2m.util

import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.HostInstance
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Identifiable
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace

class NamingUtil {

	static dispatch def name(HostInstance cpsHost) {
		cpsHost.nodeIp
	}

	static dispatch def name(Identifiable cpsIdentifiable) {
		cpsIdentifiable.id
	}

	static dispatch def name(DeploymentHost depHost) {
		depHost.ip
	}

	static dispatch def name(DeploymentApplication depApplication) {
		depApplication.id
	}

	static dispatch def name(DeploymentElement depElement) {
		depElement.description
	}

	static dispatch def String name(CPS2DeplyomentTrace trace) {
		'''[«FOR ce : trace.cpsElements SEPARATOR ", "»«ce.name»«ENDFOR»]->[«FOR de : trace.deploymentElements SEPARATOR ", "»«de.
			name»«ENDFOR»]'''
	}
}
