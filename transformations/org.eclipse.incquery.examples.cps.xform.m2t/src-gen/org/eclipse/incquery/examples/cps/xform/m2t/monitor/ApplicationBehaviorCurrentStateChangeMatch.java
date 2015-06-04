package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Arrays;
import java.util.List;
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication;
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.ApplicationBehaviorCurrentStateChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.impl.BasePatternMatch;
import org.eclipse.incquery.runtime.exception.IncQueryException;

/**
 * Pattern-specific match representation of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.applicationBehaviorCurrentStateChange pattern,
 * to be used in conjunction with {@link ApplicationBehaviorCurrentStateChangeMatcher}.
 * 
 * <p>Class fields correspond to parameters of the pattern. Fields with value null are considered unassigned.
 * Each instance is a (possibly partial) substitution of pattern parameters,
 * usable to represent a match of the pattern in the result of a query,
 * or to specify the bound (fixed) input parameters when issuing a query.
 * 
 * @see ApplicationBehaviorCurrentStateChangeMatcher
 * @see ApplicationBehaviorCurrentStateChangeProcessor
 * 
 */
@SuppressWarnings("all")
public abstract class ApplicationBehaviorCurrentStateChangeMatch extends BasePatternMatch {
  private DeploymentApplication fApp;
  
  private DeploymentBehavior fBeh;
  
  private static List<String> parameterNames = makeImmutableList("app", "beh");
  
  private ApplicationBehaviorCurrentStateChangeMatch(final DeploymentApplication pApp, final DeploymentBehavior pBeh) {
    this.fApp = pApp;
    this.fBeh = pBeh;
  }
  
  @Override
  public Object get(final String parameterName) {
    if ("app".equals(parameterName)) return this.fApp;
    if ("beh".equals(parameterName)) return this.fBeh;
    return null;
  }
  
  public DeploymentApplication getApp() {
    return this.fApp;
  }
  
  public DeploymentBehavior getBeh() {
    return this.fBeh;
  }
  
  @Override
  public boolean set(final String parameterName, final Object newValue) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    if ("app".equals(parameterName) ) {
    	this.fApp = (org.eclipse.incquery.examples.cps.deployment.DeploymentApplication) newValue;
    	return true;
    }
    if ("beh".equals(parameterName) ) {
    	this.fBeh = (org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) newValue;
    	return true;
    }
    return false;
  }
  
  public void setApp(final DeploymentApplication pApp) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fApp = pApp;
  }
  
  public void setBeh(final DeploymentBehavior pBeh) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fBeh = pBeh;
  }
  
  @Override
  public String patternName() {
    return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.applicationBehaviorCurrentStateChange";
  }
  
  @Override
  public List<String> parameterNames() {
    return ApplicationBehaviorCurrentStateChangeMatch.parameterNames;
  }
  
  @Override
  public Object[] toArray() {
    return new Object[]{fApp, fBeh};
  }
  
  @Override
  public ApplicationBehaviorCurrentStateChangeMatch toImmutable() {
    return isMutable() ? newMatch(fApp, fBeh) : this;
  }
  
  @Override
  public String prettyPrint() {
    StringBuilder result = new StringBuilder();
    result.append("\"app\"=" + prettyPrintValue(fApp) + ", ");
    
    result.append("\"beh\"=" + prettyPrintValue(fBeh)
    );
    return result.toString();
  }
  
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((fApp == null) ? 0 : fApp.hashCode());
    result = prime * result + ((fBeh == null) ? 0 : fBeh.hashCode());
    return result;
  }
  
  @Override
  public boolean equals(final Object obj) {
    if (this == obj)
    	return true;
    if (!(obj instanceof ApplicationBehaviorCurrentStateChangeMatch)) { // this should be infrequent
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
    ApplicationBehaviorCurrentStateChangeMatch other = (ApplicationBehaviorCurrentStateChangeMatch) obj;
    if (fApp == null) {if (other.fApp != null) return false;}
    else if (!fApp.equals(other.fApp)) return false;
    if (fBeh == null) {if (other.fBeh != null) return false;}
    else if (!fBeh.equals(other.fBeh)) return false;
    return true;
  }
  
  @Override
  public ApplicationBehaviorCurrentStateChangeQuerySpecification specification() {
    try {
    	return ApplicationBehaviorCurrentStateChangeQuerySpecification.instance();
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
  public static ApplicationBehaviorCurrentStateChangeMatch newEmptyMatch() {
    return new Mutable(null, null);
  }
  
  /**
   * Returns a mutable (partial) match.
   * Fields of the mutable match can be filled to create a partial match, usable as matcher input.
   * 
   * @param pApp the fixed value of pattern parameter app, or null if not bound.
   * @param pBeh the fixed value of pattern parameter beh, or null if not bound.
   * @return the new, mutable (partial) match object.
   * 
   */
  public static ApplicationBehaviorCurrentStateChangeMatch newMutableMatch(final DeploymentApplication pApp, final DeploymentBehavior pBeh) {
    return new Mutable(pApp, pBeh);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pApp the fixed value of pattern parameter app, or null if not bound.
   * @param pBeh the fixed value of pattern parameter beh, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public static ApplicationBehaviorCurrentStateChangeMatch newMatch(final DeploymentApplication pApp, final DeploymentBehavior pBeh) {
    return new Immutable(pApp, pBeh);
  }
  
  private static final class Mutable extends ApplicationBehaviorCurrentStateChangeMatch {
    Mutable(final DeploymentApplication pApp, final DeploymentBehavior pBeh) {
      super(pApp, pBeh);
    }
    
    @Override
    public boolean isMutable() {
      return true;
    }
  }
  
  private static final class Immutable extends ApplicationBehaviorCurrentStateChangeMatch {
    Immutable(final DeploymentApplication pApp, final DeploymentBehavior pBeh) {
      super(pApp, pBeh);
    }
    
    @Override
    public boolean isMutable() {
      return false;
    }
  }
}
