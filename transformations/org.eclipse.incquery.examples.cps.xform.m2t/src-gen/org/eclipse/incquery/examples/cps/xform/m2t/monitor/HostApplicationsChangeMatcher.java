package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostApplicationsChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.HostApplicationsChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.impl.BaseMatcher;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.incquery.runtime.matchers.tuple.Tuple;
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil;

/**
 * Generated pattern matcher API of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.hostApplicationsChange pattern,
 * providing pattern-specific query methods.
 * 
 * <p>Use the pattern matcher on a given model via {@link #on(IncQueryEngine)},
 * e.g. in conjunction with {@link IncQueryEngine#on(Notifier)}.
 * 
 * <p>Matches of the pattern will be represented as {@link HostApplicationsChangeMatch}.
 * 
 * <p>Original source:
 * <code><pre>
 * pattern hostApplicationsChange(deploymentHost : DeploymentHost) {
 * 	DeploymentHost.applications(deploymentHost, _);
 * }
 * </pre></code>
 * 
 * @see HostApplicationsChangeMatch
 * @see HostApplicationsChangeProcessor
 * @see HostApplicationsChangeQuerySpecification
 * 
 */
@SuppressWarnings("all")
public class HostApplicationsChangeMatcher extends BaseMatcher<HostApplicationsChangeMatch> {
  /**
   * Initializes the pattern matcher within an existing EMF-IncQuery engine.
   * If the pattern matcher is already constructed in the engine, only a light-weight reference is returned.
   * The match set will be incrementally refreshed upon updates.
   * @param engine the existing EMF-IncQuery engine in which this matcher will be created.
   * @throws IncQueryException if an error occurs during pattern matcher creation
   * 
   */
  public static HostApplicationsChangeMatcher on(final IncQueryEngine engine) throws IncQueryException {
    // check if matcher already exists
    HostApplicationsChangeMatcher matcher = engine.getExistingMatcher(querySpecification());
    if (matcher == null) {
    	matcher = new HostApplicationsChangeMatcher(engine);
    	// do not have to "put" it into engine.matchers, reportMatcherInitialized() will take care of it
    }
    return matcher;
  }
  
  private final static int POSITION_DEPLOYMENTHOST = 0;
  
  private final static Logger LOGGER = IncQueryLoggingUtil.getLogger(HostApplicationsChangeMatcher.class);
  
  /**
   * Initializes the pattern matcher over a given EMF model root (recommended: Resource or ResourceSet).
   * If a pattern matcher is already constructed with the same root, only a light-weight reference is returned.
   * The scope of pattern matching will be the given EMF model root and below (see FAQ for more precise definition).
   * The match set will be incrementally refreshed upon updates from this scope.
   * <p>The matcher will be created within the managed {@link IncQueryEngine} belonging to the EMF model root, so
   * multiple matchers will reuse the same engine and benefit from increased performance and reduced memory footprint.
   * @param emfRoot the root of the EMF containment hierarchy where the pattern matcher will operate. Recommended: Resource or ResourceSet.
   * @throws IncQueryException if an error occurs during pattern matcher creation
   * @deprecated use {@link #on(IncQueryEngine)} instead, e.g. in conjunction with {@link IncQueryEngine#on(Notifier)}
   * 
   */
  @Deprecated
  public HostApplicationsChangeMatcher(final Notifier emfRoot) throws IncQueryException {
    this(IncQueryEngine.on(emfRoot));
  }
  
  /**
   * Initializes the pattern matcher within an existing EMF-IncQuery engine.
   * If the pattern matcher is already constructed in the engine, only a light-weight reference is returned.
   * The match set will be incrementally refreshed upon updates.
   * @param engine the existing EMF-IncQuery engine in which this matcher will be created.
   * @throws IncQueryException if an error occurs during pattern matcher creation
   * @deprecated use {@link #on(IncQueryEngine)} instead
   * 
   */
  @Deprecated
  public HostApplicationsChangeMatcher(final IncQueryEngine engine) throws IncQueryException {
    super(engine, querySpecification());
  }
  
  /**
   * Returns the set of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return matches represented as a HostApplicationsChangeMatch object.
   * 
   */
  public Collection<HostApplicationsChangeMatch> getAllMatches(final DeploymentHost pDeploymentHost) {
    return rawGetAllMatches(new Object[]{pDeploymentHost});
  }
  
  /**
   * Returns an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return a match represented as a HostApplicationsChangeMatch object, or null if no match is found.
   * 
   */
  public HostApplicationsChangeMatch getOneArbitraryMatch(final DeploymentHost pDeploymentHost) {
    return rawGetOneArbitraryMatch(new Object[]{pDeploymentHost});
  }
  
  /**
   * Indicates whether the given combination of specified pattern parameters constitute a valid pattern match,
   * under any possible substitution of the unspecified parameters (if any).
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return true if the input is a valid (partial) match of the pattern.
   * 
   */
  public boolean hasMatch(final DeploymentHost pDeploymentHost) {
    return rawHasMatch(new Object[]{pDeploymentHost});
  }
  
  /**
   * Returns the number of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return the number of pattern matches found.
   * 
   */
  public int countMatches(final DeploymentHost pDeploymentHost) {
    return rawCountMatches(new Object[]{pDeploymentHost});
  }
  
  /**
   * Executes the given processor on each match of the pattern that conforms to the given fixed values of some parameters.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @param processor the action that will process each pattern match.
   * 
   */
  public void forEachMatch(final DeploymentHost pDeploymentHost, final IMatchProcessor<? super HostApplicationsChangeMatch> processor) {
    rawForEachMatch(new Object[]{pDeploymentHost}, processor);
  }
  
  /**
   * Executes the given processor on an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @param processor the action that will process the selected match.
   * @return true if the pattern has at least one match with the given parameter values, false if the processor was not invoked
   * 
   */
  public boolean forOneArbitraryMatch(final DeploymentHost pDeploymentHost, final IMatchProcessor<? super HostApplicationsChangeMatch> processor) {
    return rawForOneArbitraryMatch(new Object[]{pDeploymentHost}, processor);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public HostApplicationsChangeMatch newMatch(final DeploymentHost pDeploymentHost) {
    return HostApplicationsChangeMatch.newMatch(pDeploymentHost);
  }
  
  /**
   * Retrieve the set of values that occur in matches for deploymentHost.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  protected Set<DeploymentHost> rawAccumulateAllValuesOfdeploymentHost(final Object[] parameters) {
    Set<DeploymentHost> results = new HashSet<DeploymentHost>();
    rawAccumulateAllValues(POSITION_DEPLOYMENTHOST, parameters, results);
    return results;
  }
  
  /**
   * Retrieve the set of values that occur in matches for deploymentHost.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<DeploymentHost> getAllValuesOfdeploymentHost() {
    return rawAccumulateAllValuesOfdeploymentHost(emptyArray());
  }
  
  @Override
  protected HostApplicationsChangeMatch tupleToMatch(final Tuple t) {
    try {
    	return HostApplicationsChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentHost) t.get(POSITION_DEPLOYMENTHOST));
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in tuple not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected HostApplicationsChangeMatch arrayToMatch(final Object[] match) {
    try {
    	return HostApplicationsChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentHost) match[POSITION_DEPLOYMENTHOST]);
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in array not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected HostApplicationsChangeMatch arrayToMatchMutable(final Object[] match) {
    try {
    	return HostApplicationsChangeMatch.newMutableMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentHost) match[POSITION_DEPLOYMENTHOST]);
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in array not properly typed!",e);
    	return null;
    }
  }
  
  /**
   * @return the singleton instance of the query specification of this pattern
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static IQuerySpecification<HostApplicationsChangeMatcher> querySpecification() throws IncQueryException {
    return HostApplicationsChangeQuerySpecification.instance();
  }
}
