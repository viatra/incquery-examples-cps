package org.eclipse.incquery.examples.cps.xform.m2t.util

import com.google.common.base.CaseFormat
import org.eclipse.core.resources.IFolder
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.xform.m2t.api.ICPSGenerator


class GeneratorUtil {
	
	def generateAll(Deployment deployment, ICPSGenerator generator, IFolder folder) {
		for (host : deployment.hosts) {
			GeneratorHelper.createFile(folder, "Host" + purify(host.ip) + ".java", false,
				generator.generateHostCode(host), true);
			for (app : host.applications) {
				GeneratorHelper.createFile(folder, purify(app.id) + "Application.java", false,
					generator.generateApplicationCode(app), true);

				val behavior = app.behavior
				if(behavior!=null){
					GeneratorHelper.createFile(folder, "Behavior" + purify(behavior.description) + ".java", false,
					generator.generateBehaviorCode(behavior), true);
				}
				
			}
		}
	}
	
	def purify(String string){
		return string.replaceAll("[^A-Za-z0-9]", "")
	}
	
	def purifyAndToUpperCamel(String string){
		var String str = string.replace(' ', '_').toLowerCase.purify
		return CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.UPPER_CAMEL, str);
	}
}