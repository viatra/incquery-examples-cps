package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostApplicationsChangeMatch;
import org.eclipse.incquery.runtime.api.IMatchProcessor;

/**
 * A match processor tailored for the org.eclipse.incquery.examples.cps.xform.m2t.monitor.hostApplicationsChange pattern.
 * 
 * Clients should derive an (anonymous) class that implements the abstract process().
 * 
 */
@SuppressWarnings("all")
public abstract class HostApplicationsChangeProcessor implements IMatchProcessor<HostApplicationsChangeMatch> {
  /**
   * Defines the action that is to be executed on each match.
   * @param pDeploymentHost the value of pattern parameter deploymentHost in the currently processed match
   * 
   */
  public abstract void process(final DeploymentHost pDeploymentHost);
  
  @Override
  public void process(final HostApplicationsChangeMatch match) {
    process(match.getDeploymentHost());
  }
}
