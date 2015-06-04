package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostIpChangeMatch;
import org.eclipse.incquery.runtime.api.IMatchProcessor;

/**
 * A match processor tailored for the org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostIpChange pattern.
 * 
 * Clients should derive an (anonymous) class that implements the abstract process().
 * 
 */
@SuppressWarnings("all")
public abstract class DeploymentHostIpChangeProcessor implements IMatchProcessor<DeploymentHostIpChangeMatch> {
  /**
   * Defines the action that is to be executed on each match.
   * @param pDeployment the value of pattern parameter deployment in the currently processed match
   * 
   */
  public abstract void process(final Deployment pDeployment);
  
  @Override
  public void process(final DeploymentHostIpChangeMatch match) {
    process(match.getDeployment());
  }
}
