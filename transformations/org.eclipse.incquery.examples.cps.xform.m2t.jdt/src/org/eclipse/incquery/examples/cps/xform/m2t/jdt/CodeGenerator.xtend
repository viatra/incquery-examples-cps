package org.eclipse.incquery.examples.cps.xform.m2t.jdt

import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.api.ICPSGenerator
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.exceptions.CPSGeneratorException
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.utils.FormatterUtil

class CodeGenerator implements ICPSGenerator {
	
	val Generator generator;
	
	new (String projectName, IncQueryEngine engine) {
		generator = new Generator(projectName, engine);
	}
	
	override generateHostCode(DeploymentHost host) throws CPSGeneratorException {
		FormatterUtil.formatCode(generator.generateHostCode(host))
	}
	
	override generateApplicationCode(DeploymentApplication application) throws CPSGeneratorException {
		FormatterUtil.formatCode(generator.generateApplicationCode(application))
	}
	
	override generateBehaviorCode(DeploymentBehavior behavior) throws CPSGeneratorException {
		FormatterUtil.formatCode(generator.generateBehaviorCode(behavior))
	}
	
	override generateDeploymentCode(Deployment deployment) throws CPSGeneratorException {
		
	}
	
}