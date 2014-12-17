package org.eclipse.incquery.examples.cps.xform.m2t.util

import org.eclipse.core.resources.IFolder
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator

class GeneratorUtil {
	
	def static generateAll(Deployment deployment, ICPSGenerator generator, IFolder folder) {
		
		val purifier = new org.eclipse.incquery.examples.cps.xform.m2t.distributed.utils.GeneratorHelper 
		
		for (host : deployment.hosts) {
			GeneratorHelper.createFile(folder, "Host" + purifier.purify(host.ip) + ".java", false,
				generator.generateHostCode(host), true);
			for (app : host.applications) {
				GeneratorHelper.createFile(folder, purifier.purify(app.id) + "Application.java", false,
					generator.generateApplicationCode(app), true);

				val behavior = app.behavior
				GeneratorHelper.createFile(folder, "Behavior" + purifier.purify(behavior.description) + ".java", false,
					generator.generateBehaviorCode(behavior), true);
			}
		}
	}
	
}