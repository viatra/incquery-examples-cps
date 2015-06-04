package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition;
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TriggerChangeMatch;
import org.eclipse.incquery.runtime.api.IMatchProcessor;

/**
 * A match processor tailored for the org.eclipse.incquery.examples.cps.xform.m2t.monitor.triggerChange pattern.
 * 
 * Clients should derive an (anonymous) class that implements the abstract process().
 * 
 */
@SuppressWarnings("all")
public abstract class TriggerChangeProcessor implements IMatchProcessor<TriggerChangeMatch> {
  /**
   * Defines the action that is to be executed on each match.
   * @param pBehavior the value of pattern parameter behavior in the currently processed match
   * @param pTransition the value of pattern parameter transition in the currently processed match
   * 
   */
  public abstract void process(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition);
  
  @Override
  public void process(final TriggerChangeMatch match) {
    process(match.getBehavior(), match.getTransition());
  }
}
