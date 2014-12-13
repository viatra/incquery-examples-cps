package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.exception.IncQueryException;

public interface IDeploymentChangeMonitor {

	/**
	 * Sets the model whose changes are observed. Also creates an initial checkpoint with no changes registered.
	 * @param deployment the deployment model
	 * @param engine engine associated with the 
	 * @throws IncQueryException 
	 */
	void startMonitoring(Deployment deployment, IncQueryEngine engine) throws IncQueryException;
	
	/**
	 * Creates a checkpoint which means:
	 * <li>Model changes since the last checkpont are saved</li>
	 * <li>The model changes in the future are tracked separately from the changes before the checkpoint</li>
	 * @return the DTO containing the changed elements since the last checkpoint
	 */
	DeploymentChangeDelta createCheckpoint();
	
	/**
	 * Returns all changed elements between the last two checkpoints
	 * @return the DTO containing the changed elements
	 */
	DeploymentChangeDelta getDeltaSinceLastCheckpoint();
	
}
