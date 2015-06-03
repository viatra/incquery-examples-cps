package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostIpChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.DeploymentHostIpChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.impl.BaseMatcher;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.incquery.runtime.matchers.tuple.Tuple;
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil;

/**
 * Generated pattern matcher API of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostIpChange pattern,
 * providing pattern-specific query methods.
 * 
 * <p>Use the pattern matcher on a given model via {@link #on(IncQueryEngine)},
 * e.g. in conjunction with {@link IncQueryEngine#on(Notifier)}.
 * 
 * <p>Matches of the pattern will be represented as {@link DeploymentHostIpChangeMatch}.
 * 
 * <p>Original source:
 * <code><pre>
 * pattern deploymentHostIpChange(deployment : Deployment) {
 * 	Deployment.hosts.ip(deployment, _);
 * }
 * </pre></code>
 * 
 * @see DeploymentHostIpChangeMatch
 * @see DeploymentHostIpChangeProcessor
 * @see DeploymentHostIpChangeQuerySpecification
 * 
 */
@SuppressWarnings("all")
public class DeploymentHostIpChangeMatcher extends BaseMatcher<DeploymentHostIpChangeMatch> {
  /**
   * Initializes the pattern matcher within an existing EMF-IncQuery engine.
   * If the pattern matcher is already constructed in the engine, only a light-weight reference is returned.
   * The match set will be incrementally refreshed upon updates.
   * @param engine the existing EMF-IncQuery engine in which this matcher will be created.
   * @throws IncQueryException if an error occurs during pattern matcher creation
   * 
   */
  public static DeploymentHostIpChangeMatcher on(final IncQueryEngine engine) throws IncQueryException {
    // check if matcher already exists
    DeploymentHostIpChangeMatcher matcher = engine.getExistingMatcher(querySpecification());
    if (matcher == null) {
    	matcher = new DeploymentHostIpChangeMatcher(engine);
    	// do not have to "put" it into engine.matchers, reportMatcherInitialized() will take care of it
    }
    return matcher;
  }
  
  private final static int POSITION_DEPLOYMENT = 0;
  
  private final static Logger LOGGER = IncQueryLoggingUtil.getLogger(DeploymentHostIpChangeMatcher.class);
  
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
  public DeploymentHostIpChangeMatcher(final Notifier emfRoot) throws IncQueryException {
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
  public DeploymentHostIpChangeMatcher(final IncQueryEngine engine) throws IncQueryException {
    super(engine, querySpecification());
  }
  
  /**
   * Returns the set of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return matches represented as a DeploymentHostIpChangeMatch object.
   * 
   */
  public Collection<DeploymentHostIpChangeMatch> getAllMatches(final Deployment pDeployment) {
    return rawGetAllMatches(new Object[]{pDeployment});
  }
  
  /**
   * Returns an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return a match represented as a DeploymentHostIpChangeMatch object, or null if no match is found.
   * 
   */
  public DeploymentHostIpChangeMatch getOneArbitraryMatch(final Deployment pDeployment) {
    return rawGetOneArbitraryMatch(new Object[]{pDeployment});
  }
  
  /**
   * Indicates whether the given combination of specified pattern parameters constitute a valid pattern match,
   * under any possible substitution of the unspecified parameters (if any).
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return true if the input is a valid (partial) match of the pattern.
   * 
   */
  public boolean hasMatch(final Deployment pDeployment) {
    return rawHasMatch(new Object[]{pDeployment});
  }
  
  /**
   * Returns the number of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return the number of pattern matches found.
   * 
   */
  public int countMatches(final Deployment pDeployment) {
    return rawCountMatches(new Object[]{pDeployment});
  }
  
  /**
   * Executes the given processor on each match of the pattern that conforms to the given fixed values of some parameters.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @param processor the action that will process each pattern match.
   * 
   */
  public void forEachMatch(final Deployment pDeployment, final IMatchProcessor<? super DeploymentHostIpChangeMatch> processor) {
    rawForEachMatch(new Object[]{pDeployment}, processor);
  }
  
  /**
   * Executes the given processor on an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @param processor the action that will process the selected match.
   * @return true if the pattern has at least one match with the given parameter values, false if the processor was not invoked
   * 
   */
  public boolean forOneArbitraryMatch(final Deployment pDeployment, final IMatchProcessor<? super DeploymentHostIpChangeMatch> processor) {
    return rawForOneArbitraryMatch(new Object[]{pDeployment}, processor);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public DeploymentHostIpChangeMatch newMatch(final Deployment pDeployment) {
    return DeploymentHostIpChangeMatch.newMatch(pDeployment);
  }
  
  /**
   * Retrieve the set of values that occur in matches for deployment.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  protected Set<Deployment> rawAccumulateAllValuesOfdeployment(final Object[] parameters) {
    Set<Deployment> results = new HashSet<Deployment>();
    rawAccumulateAllValues(POSITION_DEPLOYMENT, parameters, results);
    return results;
  }
  
  /**
   * Retrieve the set of values that occur in matches for deployment.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<Deployment> getAllValuesOfdeployment() {
    return rawAccumulateAllValuesOfdeployment(emptyArray());
  }
  
  @Override
  protected DeploymentHostIpChangeMatch tupleToMatch(final Tuple t) {
    try {
    	return DeploymentHostIpChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.Deployment) t.get(POSITION_DEPLOYMENT));
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in tuple not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected DeploymentHostIpChangeMatch arrayToMatch(final Object[] match) {
    try {
    	return DeploymentHostIpChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.Deployment) match[POSITION_DEPLOYMENT]);
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in array not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected DeploymentHostIpChangeMatch arrayToMatchMutable(final Object[] match) {
    try {
    	return DeploymentHostIpChangeMatch.newMutableMatch((org.eclipse.incquery.examples.cps.deployment.Deployment) match[POSITION_DEPLOYMENT]);
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
  public static IQuerySpecification<DeploymentHostIpChangeMatcher> querySpecification() throws IncQueryException {
    return DeploymentHostIpChangeQuerySpecification.instance();
  }
}
