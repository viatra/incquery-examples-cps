package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationIdChangeMatch;
import org.eclipse.incquery.runtime.api.IMatchProcessor;

/**
 * A match processor tailored for the org.eclipse.incquery.examples.cps.xform.m2t.monitor.applicationIdChange pattern.
 * 
 * Clients should derive an (anonymous) class that implements the abstract process().
 * 
 */
@SuppressWarnings("all")
public abstract class ApplicationIdChangeProcessor implements IMatchProcessor<ApplicationIdChangeMatch> {
  /**
   * Defines the action that is to be executed on each match.
   * @param pApp the value of pattern parameter app in the currently processed match
   * 
   */
  public abstract void process(final DeploymentApplication pApp);
  
  @Override
  public void process(final ApplicationIdChangeMatch match) {
    process(match.getApp());
  }
}
