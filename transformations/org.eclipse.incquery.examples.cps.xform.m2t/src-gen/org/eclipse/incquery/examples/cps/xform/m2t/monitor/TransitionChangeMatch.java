package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Arrays;
import java.util.List;
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.TransitionChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.impl.BasePatternMatch;
import org.eclipse.incquery.runtime.exception.IncQueryException;

/**
 * Pattern-specific match representation of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.transitionChange pattern,
 * to be used in conjunction with {@link TransitionChangeMatcher}.
 * 
 * <p>Class fields correspond to parameters of the pattern. Fields with value null are considered unassigned.
 * Each instance is a (possibly partial) substitution of pattern parameters,
 * usable to represent a match of the pattern in the result of a query,
 * or to specify the bound (fixed) input parameters when issuing a query.
 * 
 * @see TransitionChangeMatcher
 * @see TransitionChangeProcessor
 * 
 */
@SuppressWarnings("all")
public abstract class TransitionChangeMatch extends BasePatternMatch {
  private DeploymentBehavior fBehavior;
  
  private static List<String> parameterNames = makeImmutableList("behavior");
  
  private TransitionChangeMatch(final DeploymentBehavior pBehavior) {
    this.fBehavior = pBehavior;
  }
  
  @Override
  public Object get(final String parameterName) {
    if ("behavior".equals(parameterName)) return this.fBehavior;
    return null;
  }
  
  public DeploymentBehavior getBehavior() {
    return this.fBehavior;
  }
  
  @Override
  public boolean set(final String parameterName, final Object newValue) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    if ("behavior".equals(parameterName) ) {
    	this.fBehavior = (org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) newValue;
    	return true;
    }
    return false;
  }
  
  public void setBehavior(final DeploymentBehavior pBehavior) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fBehavior = pBehavior;
  }
  
  @Override
  public String patternName() {
    return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.transitionChange";
  }
  
  @Override
  public List<String> parameterNames() {
    return TransitionChangeMatch.parameterNames;
  }
  
  @Override
  public Object[] toArray() {
    return new Object[]{fBehavior};
  }
  
  @Override
  public TransitionChangeMatch toImmutable() {
    return isMutable() ? newMatch(fBehavior) : this;
  }
  
  @Override
  public String prettyPrint() {
    StringBuilder result = new StringBuilder();
    result.append("\"behavior\"=" + prettyPrintValue(fBehavior)
    );
    return result.toString();
  }
  
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((fBehavior == null) ? 0 : fBehavior.hashCode());
    return result;
  }
  
  @Override
  public boolean equals(final Object obj) {
    if (this == obj)
    	return true;
    if (!(obj instanceof TransitionChangeMatch)) { // this should be infrequent
    	if (obj == null) {
    		return false;
    	}
    	if (!(obj instanceof IPatternMatch)) {
    		return false;
    	}
    	IPatternMatch otherSig  = (IPatternMatch) obj;
    	if (!specification().equals(otherSig.specification()))
    		return false;
    	return Arrays.deepEquals(toArray(), otherSig.toArray());
    }
    TransitionChangeMatch other = (TransitionChangeMatch) obj;
    if (fBehavior == null) {if (other.fBehavior != null) return false;}
    else if (!fBehavior.equals(other.fBehavior)) return false;
    return true;
  }
  
  @Override
  public TransitionChangeQuerySpecification specification() {
    try {
    	return TransitionChangeQuerySpecification.instance();
    } catch (IncQueryException ex) {
     	// This cannot happen, as the match object can only be instantiated if the query specification exists
     	throw new IllegalStateException (ex);
    }
  }
  
  /**
   * Returns an empty, mutable match.
   * Fields of the mutable match can be filled to create a partial match, usable as matcher input.
   * 
   * @return the empty match.
   * 
   */
  public static TransitionChangeMatch newEmptyMatch() {
    return new Mutable(null);
  }
  
  /**
   * Returns a mutable (partial) match.
   * Fields of the mutable match can be filled to create a partial match, usable as matcher input.
   * 
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return the new, mutable (partial) match object.
   * 
   */
  public static TransitionChangeMatch newMutableMatch(final DeploymentBehavior pBehavior) {
    return new Mutable(pBehavior);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pBehavior the fixed value of pattern parameter behavior, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public static TransitionChangeMatch newMatch(final DeploymentBehavior pBehavior) {
    return new Immutable(pBehavior);
  }
  
  private static final class Mutable extends TransitionChangeMatch {
    Mutable(final DeploymentBehavior pBehavior) {
      super(pBehavior);
    }
    
    @Override
    public boolean isMutable() {
      return true;
    }
  }
  
  private static final class Immutable extends TransitionChangeMatch {
    Immutable(final DeploymentBehavior pBehavior) {
      super(pBehavior);
    }
    
    @Override
    public boolean isMutable() {
      return false;
    }
  }
}
