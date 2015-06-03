package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TransitionChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.TransitionChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.impl.BaseMatcher;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.incquery.runtime.matchers.tuple.Tuple;
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil;

/**
 * Generated pattern matcher API of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.transitionChange pattern,
 * providing pattern-specific query methods.
 * 
 * <p>Use the pattern matcher on a given model via {@link #on(IncQueryEngine)},
 * e.g. in conjunction with {@link IncQueryEngine#on(Notifier)}.
 * 
 * <p>Matches of the pattern will be represented as {@link TransitionChangeMatch}.
 * 
 * <p>Original source:
 * <code><pre>
 * pattern transitionChange(behavior : DeploymentBehavior) {
 * 	DeploymentBehavior.transitions(behavior, _);
 * }
 * </pre></code>
 * 
 * @see TransitionChangeMatch
 * @see TransitionChangeProcessor
 * @see TransitionChangeQuerySpecification
 * 
 */
@SuppressWarnings("all")
public class TransitionChangeMatcher extends BaseMatcher<TransitionChangeMatch> {
  /**
   * Initializes the pattern matcher within an existing EMF-IncQuery engine.
   * If the pattern matcher is already constructed in the engine, only a light-weight reference is returned.
   * The match set will be incrementally refreshed upon updates.
   * @param engine the existing EMF-IncQuery engine in which this matcher will be created.
   * @throws IncQueryException if an error occurs during pattern matcher creation
   * 
   */
  public static TransitionChangeMatcher on(final IncQueryEngine engine) throws IncQueryException {
    // check if matcher already exists
    TransitionChangeMatcher matcher = engine.getExistingMatcher(querySpecification());
    if (matcher == null) {
    	matcher = new TransitionChangeMatcher(engine);
    	// do not have to "put" it into engine.matchers, reportMatcherInitialized() will take care of it
    }
    return matcher;
  }
  
  private final static int POSITION_BEHAVIOR = 0;
  
  private final static Logger LOGGER = IncQueryLoggingUtil.getLogger(TransitionChangeMatcher.class);
  
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
  public TransitionChangeMatcher(final Notifier emfRoot) throws IncQueryException {
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
  public TransitionChangeMatcher(final IncQueryEngine engine) throws IncQueryException {
    super(engine, querySpecification());
  }
  
  /**
   * Returns the set of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return matches represented as a TransitionChangeMatch object.
   * 
   */
  public Collection<TransitionChangeMatch> getAllMatches(final DeploymentBehavior pBehavior) {
    return rawGetAllMatches(new Object[]{pBehavior});
  }
  
  /**
   * Returns an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return a match represented as a TransitionChangeMatch object, or null if no match is found.
   * 
   */
  public TransitionChangeMatch getOneArbitraryMatch(final DeploymentBehavior pBehavior) {
    return rawGetOneArbitraryMatch(new Object[]{pBehavior});
  }
  
  /**
   * Indicates whether the given combination of specified pattern parameters constitute a valid pattern match,
   * under any possible substitution of the unspecified parameters (if any).
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return true if the input is a valid (partial) match of the pattern.
   * 
   */
  public boolean hasMatch(final DeploymentBehavior pBehavior) {
    return rawHasMatch(new Object[]{pBehavior});
  }
  
  /**
   * Returns the number of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return the number of pattern matches found.
   * 
   */
  public int countMatches(final DeploymentBehavior pBehavior) {
    return rawCountMatches(new Object[]{pBehavior});
  }
  
  /**
   * Executes the given processor on each match of the pattern that conforms to the given fixed values of some parameters.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param processor the action that will process each pattern match.
   * 
   */
  public void forEachMatch(final DeploymentBehavior pBehavior, final IMatchProcessor<? super TransitionChangeMatch> processor) {
    rawForEachMatch(new Object[]{pBehavior}, processor);
  }
  
  /**
   * Executes the given processor on an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param processor the action that will process the selected match.
   * @return true if the pattern has at least one match with the given parameter values, false if the processor was not invoked
   * 
   */
  public boolean forOneArbitraryMatch(final DeploymentBehavior pBehavior, final IMatchProcessor<? super TransitionChangeMatch> processor) {
    return rawForOneArbitraryMatch(new Object[]{pBehavior}, processor);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public TransitionChangeMatch newMatch(final DeploymentBehavior pBehavior) {
    return TransitionChangeMatch.newMatch(pBehavior);
  }
  
  /**
   * Retrieve the set of values that occur in matches for behavior.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  protected Set<DeploymentBehavior> rawAccumulateAllValuesOfbehavior(final Object[] parameters) {
    Set<DeploymentBehavior> results = new HashSet<DeploymentBehavior>();
    rawAccumulateAllValues(POSITION_BEHAVIOR, parameters, results);
    return results;
  }
  
  /**
   * Retrieve the set of values that occur in matches for behavior.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<DeploymentBehavior> getAllValuesOfbehavior() {
    return rawAccumulateAllValuesOfbehavior(emptyArray());
  }
  
  @Override
  protected TransitionChangeMatch tupleToMatch(final Tuple t) {
    try {
    	return TransitionChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) t.get(POSITION_BEHAVIOR));
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in tuple not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected TransitionChangeMatch arrayToMatch(final Object[] match) {
    try {
    	return TransitionChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) match[POSITION_BEHAVIOR]);
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in array not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected TransitionChangeMatch arrayToMatchMutable(final Object[] match) {
    try {
    	return TransitionChangeMatch.newMutableMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) match[POSITION_BEHAVIOR]);
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
  public static IQuerySpecification<TransitionChangeMatcher> querySpecification() throws IncQueryException {
    return TransitionChangeQuerySpecification.instance();
  }
}
