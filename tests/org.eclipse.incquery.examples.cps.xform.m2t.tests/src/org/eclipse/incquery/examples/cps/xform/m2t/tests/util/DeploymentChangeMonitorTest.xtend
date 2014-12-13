package org.eclipse.incquery.examples.cps.xform.m2t.tests.util

//import org.apache.log4j.Logger

import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.incquery.examples.cps.deployment.Deployment
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.DeploymentChangeMonitor
import org.eclipse.incquery.examples.cps.xform.m2t.util.monitor.IDeploymentChangeMonitor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

/**
 * Test cases for the DeploymentChangeMonitor. The cases should cover every rule defined for tracing
 * model changes at least once.
 */
class DeploymentChangeMonitorTest {

	Deployment deployment
	AdvancedIncQueryEngine engine
	IDeploymentChangeMonitor monitor

	//	extension Logger logger = Logger.getLogger("cps.DeploymentChangeMonitor")
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
	def void tearDownEngine() {
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
	// @Ignore
	@Test
	def void hostAdditionAndRemoval() {
		monitor.startMonitoring(deployment, engine)

		// Addition
		val host3 = prepareHost("host3", "1.1.1.3", deployment)

		assertTrue("Host not found in the deltas", monitor.deltaSinceLastCheckpoint.appeared.contains(host3))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.appeared.size == 1)

		// Removal
		val iterator = deployment.hosts.iterator;
		val host1 = iterator.next
		iterator.remove
		assertTrue("Host not found in the deltas", monitor.deltaSinceLastCheckpoint.disappeared.contains(host1))

		// Update: when a new element appears and uptades, it should look like appear
		assertTrue("The update list should be empty", monitor.deltaSinceLastCheckpoint.updated.size == 0)
	}

	// Test for pattern deploymentHostIpChange and hostIpChange
	// @Ignore
	@Test
	def void changeHostIPAddress() {
		monitor.startMonitoring(deployment, engine)

		// Update
		val iterator = deployment.hosts.iterator;
		var host = iterator.next

		host.ip = "2.2.2.2"
		assertTrue("Host not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(host))
		assertTrue("Deployment change not detected", monitor.deltaSinceLastCheckpoint.deploymentChanged)
		host = iterator.next
		host.ip = "2.2.2.3"
		val test = monitor.deltaSinceLastCheckpoint.updated
		assertTrue("Host not found in the deltas", test.contains(host))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 2)
	}

	// Test for pattern hostApplicationsChange
	// @Ignore
	@Test
	def void changeAppllicationsOnHost() {
		monitor.startMonitoring(deployment, engine)

		val host = deployment.hosts.iterator.next

		val app = host.applications.head
		host.applications.remove(app)

		assertTrue("Application not found in the deltas", monitor.deltaSinceLastCheckpoint.disappeared.contains(app))

		// Changes: the application deletion removes the application and its behavior from the model.
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.disappeared.size == 2)

		// Also modifies app list on host, but the host is not deleted
		assertTrue("Host not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(host))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 1)
	}

	// Test for pattern applicationIdChange
	// @Ignore
	@Test
	def void changeApplicationID() {
		monitor.startMonitoring(deployment, engine)
		val host = deployment.hosts.head
		val app = host.applications.head

		app.id = "newID"

		assertTrue("Host not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(host))
		assertTrue("Application not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(app))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 2)
	}

	// Test for pattern applicationBehaviorChange
	// @Ignore
	@Test
	def void changeCurrentStateForApplication() {
		monitor.startMonitoring(deployment, engine)
		val app = deployment.hosts.head.applications.head
		val behavior = app.behavior

		behavior.current = behavior.states.get(0)

		assertTrue("Application not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(app))

		// Due to rules for behavior, it is also in the update list
		// This could be fixed, but might not worth the overhead and complexity
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 2)
	}

	// Test for pattern behaviorChange
	// @Ignore
	@Test
	def void addStateToABehavior() {
		monitor.startMonitoring(deployment, engine)
		val behavior = deployment.hosts.head.applications.head.behavior

		behavior.states += DeploymentFactory.eINSTANCE.createBehaviorState

		assertTrue("Behavior not found in the deltas", monitor.deltaSinceLastCheckpoint.appeared.contains(behavior))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.appeared.size == 1)
	}

	// Test for pattern transitionChange
	// @Ignore 
	@Test
	def void removeStateFromABehavior() {
		monitor.startMonitoring(deployment, engine)
		val behavior = deployment.hosts.head.applications.head.behavior

		behavior.states.remove(0)

		assertTrue("Behavior not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(behavior))
		// Due to rules for appliation, it is also in the update list
		// This could be fixed, but might not worth the overhead and complexity
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 2)
	}


	// Test for pattern behaviorChange
	// @Ignore
	@Test
	def void modyfyTransitionListOfBehavior() {
		monitor.startMonitoring(deployment, engine)
		val behavior = deployment.hosts.head.applications.head.behavior

		val newTransition = DeploymentFactory.eINSTANCE.createBehaviorTransition

		behavior.transitions += newTransition

		assertTrue("Behavior not found in the deltas", monitor.deltaSinceLastCheckpoint.appeared.contains(behavior))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.appeared.size == 1)

		behavior.transitions -= newTransition
		
		// It is already in the appeared list, after additional modifications it should still be there
		assertTrue("Behavior not found in the deltas", monitor.deltaSinceLastCheckpoint.appeared.contains(behavior))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.appeared.size == 1)
	}

	// Test for pattern behaviorChange
	// @Ignore
	@Test
	def void removeTransitionFromBehavior() {
		monitor.startMonitoring(deployment, engine)
		val behavior = deployment.hosts.head.applications.head.behavior

		val transition = behavior.transitions.head

		behavior.transitions -= transition
		
		// It is already in the appeared list, after additional modifications it should still be there
		assertTrue("Behavior not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(behavior))
		// Due to rules for appliation, it is also in the update list
		// This could be fixed, but might not worth the overhead and complexity
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 2)
	}

	// Test for pattern behaviorChange
	// @Ignore
	@Test
	def void addTriggerToTransition() {
		monitor.startMonitoring(deployment, engine)
		val behavior = deployment.hosts.head.applications.head.behavior

		behavior.transitions.head.trigger += behavior.transitions.head;

		assertTrue("Behavior not found in the deltas", monitor.deltaSinceLastCheckpoint.updated.contains(behavior))
		assertTrue("Too many deltas stored", monitor.deltaSinceLastCheckpoint.updated.size == 1)
	}

}
