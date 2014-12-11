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
import org.eclipse.incquery.examples.cps.xform.m2t.listener.IDeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.After
import org.junit.Ignore

/**
 * Test cases for the DeploymentChangeMonitor. The cases should cover every rule defined for tracing
 * model changes at least once.
 */
class DeploymentChangeMonitorTest {

	Deployment deployment
	AdvancedIncQueryEngine engine
	IDeploymentChangeMonitor monitor

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
		
		engine = AdvancedIncQueryEngine.createUnmanagedEngine(deployment)
		
		monitor = new DeploymentChangeMonitor
	}
	@After
	def void tearDownEngine(){
		engine.dispose
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

	// Test for pattern deploymentHostsChange
	@Test
	def void hostAdditionAndRemoval(){
		monitor.startMonitoring(deployment,engine)
		
		// Addition
		val host3 = prepareHost("host3","1.1.1.3",deployment)
		
		assertTrue("Host not found in the deltas",monitor.deltaSinceLastCheckpoint.appeared.contains(host3))
		assertTrue("Too many deltas stored",monitor.deltaSinceLastCheckpoint.appeared.size == 1)
		
		// Removal
		val iterator = deployment.hosts.iterator;
		val host1 = iterator.next
		iterator.remove
		assertTrue("Host not found in the deltas",monitor.deltaSinceLastCheckpoint.disappeared.contains(host1))
		
		// Update: when a new element appears and uptades, it should look like appear
		assertTrue("The update list should be empty",monitor.deltaSinceLastCheckpoint.updated.size == 0)		
	}

	// Test for pattern deploymentHostIpChange and hostIpChange
	@Test
	def void deploymenthostIPChange(){
		monitor.startMonitoring(deployment,engine)
		
		// Update
		val iterator = deployment.hosts.iterator;
		var host = iterator.next

		host.ip = "2.2.2.2"
		assertTrue("Host not found in the deltas",monitor.deltaSinceLastCheckpoint.updated.contains(host))
		
		host = iterator.next
		host.ip = "2.2.2.3"		
		val test = monitor.deltaSinceLastCheckpoint.updated
		assertTrue("Host not found in the deltas",test.contains(host))
		assertTrue("Too many deltas stored",monitor.deltaSinceLastCheckpoint.updated.size == 2)		
	}

	// Test for pattern hostApplicationsChange
	@Test
	def void hostAppllicationsChange(){
		monitor.startMonitoring(deployment,engine)
		
		val host = deployment.hosts.iterator.next
		
		val app = host.applications.head
		host.applications.remove(app)
		
		println(monitor.deltaSinceLastCheckpoint.disappeared)
		println(monitor.deltaSinceLastCheckpoint.disappeared.size)
		
		assertTrue("Application not found in the deltas",monitor.deltaSinceLastCheckpoint.disappeared.contains(app))
		// Changes: the application deletion removes the application and its behavior from the model.
		assertTrue("Too many deltas stored",monitor.deltaSinceLastCheckpoint.disappeared.size == 2)
		// Also modifies app list on host, but the host is not deleted
		assertTrue("Host not found in the deltas",monitor.deltaSinceLastCheckpoint.updated.contains(host))
		assertTrue("Too many deltas stored",monitor.deltaSinceLastCheckpoint.updated.size == 1)
	}


}
