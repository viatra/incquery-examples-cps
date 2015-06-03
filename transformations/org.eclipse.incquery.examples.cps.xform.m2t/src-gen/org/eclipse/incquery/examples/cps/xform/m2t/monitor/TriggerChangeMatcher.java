package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition;
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TriggerChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.TriggerChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.impl.BaseMatcher;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.incquery.runtime.matchers.tuple.Tuple;
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil;

/**
 * Generated pattern matcher API of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.triggerChange pattern,
 * providing pattern-specific query methods.
 * 
 * <p>Use the pattern matcher on a given model via {@link #on(IncQueryEngine)},
 * e.g. in conjunction with {@link IncQueryEngine#on(Notifier)}.
 * 
 * <p>Matches of the pattern will be represented as {@link TriggerChangeMatch}.
 * 
 * <p>Original source:
 * <code><pre>
 * pattern triggerChange(behavior : DeploymentBehavior,transition) {
 * 	DeploymentBehavior.transitions(behavior,transition);
 * 	BehaviorTransition.trigger(transition,_);
 * }
 * </pre></code>
 * 
 * @see TriggerChangeMatch
 * @see TriggerChangeProcessor
 * @see TriggerChangeQuerySpecification
 * 
 */
@SuppressWarnings("all")
public class TriggerChangeMatcher extends BaseMatcher<TriggerChangeMatch> {
  /**
   * Initializes the pattern matcher within an existing EMF-IncQuery engine.
   * If the pattern matcher is already constructed in the engine, only a light-weight reference is returned.
   * The match set will be incrementally refreshed upon updates.
   * @param engine the existing EMF-IncQuery engine in which this matcher will be created.
   * @throws IncQueryException if an error occurs during pattern matcher creation
   * 
   */
  public static TriggerChangeMatcher on(final IncQueryEngine engine) throws IncQueryException {
    // check if matcher already exists
    TriggerChangeMatcher matcher = engine.getExistingMatcher(querySpecification());
    if (matcher == null) {
    	matcher = new TriggerChangeMatcher(engine);
    	// do not have to "put" it into engine.matchers, reportMatcherInitialized() will take care of it
    }
    return matcher;
  }
  
  private final static int POSITION_BEHAVIOR = 0;
  
  private final static int POSITION_TRANSITION = 1;
  
  private final static Logger LOGGER = IncQueryLoggingUtil.getLogger(TriggerChangeMatcher.class);
  
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
  public TriggerChangeMatcher(final Notifier emfRoot) throws IncQueryException {
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
  public TriggerChangeMatcher(final IncQueryEngine engine) throws IncQueryException {
    super(engine, querySpecification());
  }
  
  /**
   * Returns the set of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @return matches represented as a TriggerChangeMatch object.
   * 
   */
  public Collection<TriggerChangeMatch> getAllMatches(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition) {
    return rawGetAllMatches(new Object[]{pBehavior, pTransition});
  }
  
  /**
   * Returns an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @return a match represented as a TriggerChangeMatch object, or null if no match is found.
   * 
   */
  public TriggerChangeMatch getOneArbitraryMatch(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition) {
    return rawGetOneArbitraryMatch(new Object[]{pBehavior, pTransition});
  }
  
  /**
   * Indicates whether the given combination of specified pattern parameters constitute a valid pattern match,
   * under any possible substitution of the unspecified parameters (if any).
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @return true if the input is a valid (partial) match of the pattern.
   * 
   */
  public boolean hasMatch(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition) {
    return rawHasMatch(new Object[]{pBehavior, pTransition});
  }
  
  /**
   * Returns the number of all matches of the pattern that conform to the given fixed values of some parameters.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @return the number of pattern matches found.
   * 
   */
  public int countMatches(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition) {
    return rawCountMatches(new Object[]{pBehavior, pTransition});
  }
  
  /**
   * Executes the given processor on each match of the pattern that conforms to the given fixed values of some parameters.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @param processor the action that will process each pattern match.
   * 
   */
  public void forEachMatch(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition, final IMatchProcessor<? super TriggerChangeMatch> processor) {
    rawForEachMatch(new Object[]{pBehavior, pTransition}, processor);
  }
  
  /**
   * Executes the given processor on an arbitrarily chosen match of the pattern that conforms to the given fixed values of some parameters.
   * Neither determinism nor randomness of selection is guaranteed.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @param processor the action that will process the selected match.
   * @return true if the pattern has at least one match with the given parameter values, false if the processor was not invoked
   * 
   */
  public boolean forOneArbitraryMatch(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition, final IMatchProcessor<? super TriggerChangeMatch> processor) {
    return rawForOneArbitraryMatch(new Object[]{pBehavior, pTransition}, processor);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @param pTransition the fixed value of pattern parameter transition, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public TriggerChangeMatch newMatch(final DeploymentBehavior pBehavior, final BehaviorTransition pTransition) {
    return TriggerChangeMatch.newMatch(pBehavior, pTransition);
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
  
  /**
   * Retrieve the set of values that occur in matches for behavior.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<DeploymentBehavior> getAllValuesOfbehavior(final TriggerChangeMatch partialMatch) {
    return rawAccumulateAllValuesOfbehavior(partialMatch.toArray());
  }
  
  /**
   * Retrieve the set of values that occur in matches for behavior.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<DeploymentBehavior> getAllValuesOfbehavior(final BehaviorTransition pTransition) {
    return rawAccumulateAllValuesOfbehavior(new Object[]{
    null, 
    pTransition
    });
  }
  
  /**
   * Retrieve the set of values that occur in matches for transition.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  protected Set<BehaviorTransition> rawAccumulateAllValuesOftransition(final Object[] parameters) {
    Set<BehaviorTransition> results = new HashSet<BehaviorTransition>();
    rawAccumulateAllValues(POSITION_TRANSITION, parameters, results);
    return results;
  }
  
  /**
   * Retrieve the set of values that occur in matches for transition.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<BehaviorTransition> getAllValuesOftransition() {
    return rawAccumulateAllValuesOftransition(emptyArray());
  }
  
  /**
   * Retrieve the set of values that occur in matches for transition.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<BehaviorTransition> getAllValuesOftransition(final TriggerChangeMatch partialMatch) {
    return rawAccumulateAllValuesOftransition(partialMatch.toArray());
  }
  
  /**
   * Retrieve the set of values that occur in matches for transition.
   * @return the Set of all values, null if no parameter with the given name exists, empty set if there are no matches
   * 
   */
  public Set<BehaviorTransition> getAllValuesOftransition(final DeploymentBehavior pBehavior) {
    return rawAccumulateAllValuesOftransition(new Object[]{
    pBehavior, 
    null
    });
  }
  
  @Override
  protected TriggerChangeMatch tupleToMatch(final Tuple t) {
    try {
    	return TriggerChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) t.get(POSITION_BEHAVIOR), (org.eclipse.incquery.examples.cps.deployment.BehaviorTransition) t.get(POSITION_TRANSITION));
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in tuple not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected TriggerChangeMatch arrayToMatch(final Object[] match) {
    try {
    	return TriggerChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) match[POSITION_BEHAVIOR], (org.eclipse.incquery.examples.cps.deployment.BehaviorTransition) match[POSITION_TRANSITION]);
    } catch(ClassCastException e) {
    	LOGGER.error("Element(s) in array not properly typed!",e);
    	return null;
    }
  }
  
  @Override
  protected TriggerChangeMatch arrayToMatchMutable(final Object[] match) {
    try {
    	return TriggerChangeMatch.newMutableMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) match[POSITION_BEHAVIOR], (org.eclipse.incquery.examples.cps.deployment.BehaviorTransition) match[POSITION_TRANSITION]);
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
  public static IQuerySpecification<TriggerChangeMatcher> querySpecification() throws IncQueryException {
    return TriggerChangeQuerySpecification.instance();
  }
}
