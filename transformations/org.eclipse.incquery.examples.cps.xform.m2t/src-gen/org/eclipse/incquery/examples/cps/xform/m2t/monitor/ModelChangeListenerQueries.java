package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationBehaviorCurrentStateChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationIdChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.BehaviorChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostIpChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostsChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostApplicationsChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostIpChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TransitionChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TriggerChangeMatcher;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.ApplicationBehaviorCurrentStateChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.ApplicationIdChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.BehaviorChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.DeploymentHostIpChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.DeploymentHostsChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.HostApplicationsChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.HostIpChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.TransitionChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.TriggerChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.impl.BaseGeneratedPatternGroup;
import org.eclipse.incquery.runtime.exception.IncQueryException;

/**
 * A pattern group formed of all patterns defined in modelChangeListenerQueries.eiq.
 * 
 * <p>Use the static instance as any {@link org.eclipse.incquery.runtime.api.IPatternGroup}, to conveniently prepare
 * an EMF-IncQuery engine for matching all patterns originally defined in file modelChangeListenerQueries.eiq,
 * in order to achieve better performance than one-by-one on-demand matcher initialization.
 * 
 * <p> From package org.eclipse.incquery.examples.cps.xform.m2t.monitor, the group contains the definition of the following patterns: <ul>
 * <li>deploymentHostsChange</li>
 * <li>deploymentHostIpChange</li>
 * <li>hostApplicationsChange</li>
 * <li>hostIpChange</li>
 * <li>applicationIdChange</li>
 * <li>applicationBehaviorCurrentStateChange</li>
 * <li>behaviorChange</li>
 * <li>transitionChange</li>
 * <li>triggerChange</li>
 * </ul>
 * 
 * @see IPatternGroup
 * 
 */
@SuppressWarnings("all")
public final class ModelChangeListenerQueries extends BaseGeneratedPatternGroup {
  /**
   * Access the pattern group.
   * 
   * @return the singleton instance of the group
   * @throws IncQueryException if there was an error loading the generated code of pattern specifications
   * 
   */
  public static ModelChangeListenerQueries instance() throws IncQueryException {
    if (INSTANCE == null) {
    	INSTANCE = new ModelChangeListenerQueries();
    }
    return INSTANCE;
  }
  
  private static ModelChangeListenerQueries INSTANCE;
  
  private ModelChangeListenerQueries() throws IncQueryException {
    querySpecifications.add(DeploymentHostsChangeQuerySpecification.instance());
    querySpecifications.add(DeploymentHostIpChangeQuerySpecification.instance());
    querySpecifications.add(HostApplicationsChangeQuerySpecification.instance());
    querySpecifications.add(HostIpChangeQuerySpecification.instance());
    querySpecifications.add(ApplicationIdChangeQuerySpecification.instance());
    querySpecifications.add(ApplicationBehaviorCurrentStateChangeQuerySpecification.instance());
    querySpecifications.add(BehaviorChangeQuerySpecification.instance());
    querySpecifications.add(TransitionChangeQuerySpecification.instance());
    querySpecifications.add(TriggerChangeQuerySpecification.instance());
  }
  
  public DeploymentHostsChangeQuerySpecification getDeploymentHostsChange() throws IncQueryException {
    return DeploymentHostsChangeQuerySpecification.instance();
  }
  
  public DeploymentHostsChangeMatcher getDeploymentHostsChange(final IncQueryEngine engine) throws IncQueryException {
    return DeploymentHostsChangeMatcher.on(engine);
  }
  
  public DeploymentHostIpChangeQuerySpecification getDeploymentHostIpChange() throws IncQueryException {
    return DeploymentHostIpChangeQuerySpecification.instance();
  }
  
  public DeploymentHostIpChangeMatcher getDeploymentHostIpChange(final IncQueryEngine engine) throws IncQueryException {
    return DeploymentHostIpChangeMatcher.on(engine);
  }
  
  public HostApplicationsChangeQuerySpecification getHostApplicationsChange() throws IncQueryException {
    return HostApplicationsChangeQuerySpecification.instance();
  }
  
  public HostApplicationsChangeMatcher getHostApplicationsChange(final IncQueryEngine engine) throws IncQueryException {
    return HostApplicationsChangeMatcher.on(engine);
  }
  
  public HostIpChangeQuerySpecification getHostIpChange() throws IncQueryException {
    return HostIpChangeQuerySpecification.instance();
  }
  
  public HostIpChangeMatcher getHostIpChange(final IncQueryEngine engine) throws IncQueryException {
    return HostIpChangeMatcher.on(engine);
  }
  
  public ApplicationIdChangeQuerySpecification getApplicationIdChange() throws IncQueryException {
    return ApplicationIdChangeQuerySpecification.instance();
  }
  
  public ApplicationIdChangeMatcher getApplicationIdChange(final IncQueryEngine engine) throws IncQueryException {
    return ApplicationIdChangeMatcher.on(engine);
  }
  
  public ApplicationBehaviorCurrentStateChangeQuerySpecification getApplicationBehaviorCurrentStateChange() throws IncQueryException {
    return ApplicationBehaviorCurrentStateChangeQuerySpecification.instance();
  }
  
  public ApplicationBehaviorCurrentStateChangeMatcher getApplicationBehaviorCurrentStateChange(final IncQueryEngine engine) throws IncQueryException {
    return ApplicationBehaviorCurrentStateChangeMatcher.on(engine);
  }
  
  public BehaviorChangeQuerySpecification getBehaviorChange() throws IncQueryException {
    return BehaviorChangeQuerySpecification.instance();
  }
  
  public BehaviorChangeMatcher getBehaviorChange(final IncQueryEngine engine) throws IncQueryException {
    return BehaviorChangeMatcher.on(engine);
  }
  
  public TransitionChangeQuerySpecification getTransitionChange() throws IncQueryException {
    return TransitionChangeQuerySpecification.instance();
  }
  
  public TransitionChangeMatcher getTransitionChange(final IncQueryEngine engine) throws IncQueryException {
    return TransitionChangeMatcher.on(engine);
  }
  
  public TriggerChangeQuerySpecification getTriggerChange() throws IncQueryException {
    return TriggerChangeQuerySpecification.instance();
  }
  
  public TriggerChangeMatcher getTriggerChange(final IncQueryEngine engine) throws IncQueryException {
    return TriggerChangeMatcher.on(engine);
  }
}
