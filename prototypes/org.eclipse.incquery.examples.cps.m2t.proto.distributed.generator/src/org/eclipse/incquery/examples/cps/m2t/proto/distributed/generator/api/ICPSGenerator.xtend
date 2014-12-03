package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.api

import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication

interface ICPSGenerator {
	def CharSequence generateHostCode(DeploymentHost host)
	def CharSequence generateApplicationCode(DeploymentApplication host)
	def CharSequence generateBehaviorCode(DeploymentApplication host)
}