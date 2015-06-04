package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostsChangeMatch;
import org.eclipse.incquery.runtime.api.IMatchProcessor;

/**
 * A match processor tailored for the org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostsChange pattern.
 * 
 * Clients should derive an (anonymous) class that implements the abstract process().
 * 
 */
@SuppressWarnings("all")
public abstract class DeploymentHostsChangeProcessor implements IMatchProcessor<DeploymentHostsChangeMatch> {
  /**
   * Defines the action that is to be executed on each match.
   * @param pDeployment the value of pattern parameter deployment in the currently processed match
   * @param pHost the value of pattern parameter host in the currently processed match
   * 
   */
  public abstract void process(final Deployment pDeployment, final DeploymentHost pHost);
  
  @Override
  public void process(final DeploymentHostsChangeMatch match) {
    process(match.getDeployment(), match.getHost());
  }
}
