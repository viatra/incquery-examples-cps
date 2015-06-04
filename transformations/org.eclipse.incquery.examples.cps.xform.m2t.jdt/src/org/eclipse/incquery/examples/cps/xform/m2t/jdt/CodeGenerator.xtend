package org.eclipse.incquery.examples.cps.xform.m2t.jdt

import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2t.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.exceptions.CPSGeneratorException
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.examples.cps.xform.m2t.util.FormatterUtil

class CodeGenerator implements ICPSGenerator {
	extension FormatterUtil util = new FormatterUtil
	val Generator generator;
	
	new (String projectName, IncQueryEngine engine) {
		generator = new Generator(projectName, engine);
	}
	
	override generateHostCode(DeploymentHost host) throws CPSGeneratorException {
		formatCode(generator.generateHostCode(host))
	}
	
	override generateApplicationCode(DeploymentApplication application) throws CPSGeneratorException {
		formatCode(generator.generateApplicationCode(application))
	}
	
	override generateBehaviorCode(DeploymentBehavior behavior) throws CPSGeneratorException {
		formatCode(generator.generateBehaviorCode(behavior))
	}
	
	override generateDeploymentCode(Deployment deployment) throws CPSGeneratorException {
		
	}
	
}