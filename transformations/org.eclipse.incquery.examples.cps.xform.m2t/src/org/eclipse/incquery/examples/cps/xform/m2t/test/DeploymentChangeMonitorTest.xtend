package org.eclipse.incquery.examples.cps.xform.m2t.test

import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.junit.Before
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.junit.Test
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.examples.cps.xform.m2t.listener.DeploymentChangeMonitor

import static org.junit.Assert.*

class DeploymentChangeMonitorTest {

	Deployment deployment
	IncQueryEngine engine
	DeploymentChangeMonitor monitor

	@Before
	def void createModel() {

		deployment = DeploymentFactory.eINSTANCE.createDeployment

		val host1 = prepareHost("host1", "1.1.1.1", deployment)
		val application1 = prepareApplication("description_app1", "app1", host1)
		val behavior1 = prepareDefaultBehavior(application1)

		val host2 = prepareHost("host2", "1.1.1.2", deployment)
		val application2 = prepareApplication("description_app2", "app2", host2)
		val copier = new EcoreUtil.Copier
		val behavior2 = copier.copy(behavior1) as DeploymentBehavior
		application2.behavior = behavior2

		behavior1.transitions.head.trigger += behavior2.transitions.head
		
		engine = IncQueryEngine.on(deployment)
		
		monitor = new DeploymentChangeMonitor
		
	}

	@Test
	def void hostAddition(){
		monitor.startMonitoring(deployment,engine)
		
		val host3 = prepareHost("host3","1.1.1.3",deployment)
		
		assertTrue("Host not found in the deltas",monitor.deltaSinceLastCheckpoint.appeared.contains(host3))
		assertTrue("Too many deltas stored",monitor.deltaSinceLastCheckpoint.appeared.size == 1)
	}

	def prepareDefaultBehavior(DeploymentApplication application) {
		val behavior = DeploymentFactory.eINSTANCE.createDeploymentBehavior
		application.behavior = behavior
		val state1 = DeploymentFactory.eINSTANCE.createBehaviorState
		val state2 = DeploymentFactory.eINSTANCE.createBehaviorState
		behavior.current = state1
		behavior.states += #[state1, state2]
		val transition = DeploymentFactory.eINSTANCE.createBehaviorTransition
		behavior.transitions += transition
		state1.outgoing += transition
		transition.to = state2
		return behavior
	}

	def prepareApplication(String description, String id, DeploymentHost host) {
		val app = DeploymentFactory.eINSTANCE.createDeploymentApplication
		app.description = description
		app.id = id
		host.applications += app
		return app
	}

	def prepareHost(String description, String ip, Deployment deployment) {
		val host = DeploymentFactory.eINSTANCE.createDeploymentHost
		host.description = description
		host.ip = ip
		deployment.hosts += host
		return host
	}

}
