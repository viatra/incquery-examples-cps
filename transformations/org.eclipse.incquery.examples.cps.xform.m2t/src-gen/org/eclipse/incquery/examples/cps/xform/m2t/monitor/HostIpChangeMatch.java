package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Arrays;
import java.util.List;
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.HostIpChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.impl.BasePatternMatch;
import org.eclipse.incquery.runtime.exception.IncQueryException;

/**
 * Pattern-specific match representation of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.hostIpChange pattern,
 * to be used in conjunction with {@link HostIpChangeMatcher}.
 * 
 * <p>Class fields correspond to parameters of the pattern. Fields with value null are considered unassigned.
 * Each instance is a (possibly partial) substitution of pattern parameters,
 * usable to represent a match of the pattern in the result of a query,
 * or to specify the bound (fixed) input parameters when issuing a query.
 * 
 * @see HostIpChangeMatcher
 * @see HostIpChangeProcessor
 * 
 */
@SuppressWarnings("all")
public abstract class HostIpChangeMatch extends BasePatternMatch {
  private DeploymentHost fDeploymentHost;
  
  private static List<String> parameterNames = makeImmutableList("deploymentHost");
  
  private HostIpChangeMatch(final DeploymentHost pDeploymentHost) {
    this.fDeploymentHost = pDeploymentHost;
  }
  
  @Override
  public Object get(final String parameterName) {
    if ("deploymentHost".equals(parameterName)) return this.fDeploymentHost;
    return null;
  }
  
  public DeploymentHost getDeploymentHost() {
    return this.fDeploymentHost;
  }
  
  @Override
  public boolean set(final String parameterName, final Object newValue) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    if ("deploymentHost".equals(parameterName) ) {
    	this.fDeploymentHost = (org.eclipse.incquery.examples.cps.deployment.DeploymentHost) newValue;
    	return true;
    }
    return false;
  }
  
  public void setDeploymentHost(final DeploymentHost pDeploymentHost) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fDeploymentHost = pDeploymentHost;
  }
  
  @Override
  public String patternName() {
    return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.hostIpChange";
  }
  
  @Override
  public List<String> parameterNames() {
    return HostIpChangeMatch.parameterNames;
  }
  
  @Override
  public Object[] toArray() {
    return new Object[]{fDeploymentHost};
  }
  
  @Override
  public HostIpChangeMatch toImmutable() {
    return isMutable() ? newMatch(fDeploymentHost) : this;
  }
  
  @Override
  public String prettyPrint() {
    StringBuilder result = new StringBuilder();
    result.append("\"deploymentHost\"=" + prettyPrintValue(fDeploymentHost)
    );
    return result.toString();
  }
  
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((fDeploymentHost == null) ? 0 : fDeploymentHost.hashCode());
    return result;
  }
  
  @Override
  public boolean equals(final Object obj) {
    if (this == obj)
    	return true;
    if (!(obj instanceof HostIpChangeMatch)) { // this should be infrequent
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
    HostIpChangeMatch other = (HostIpChangeMatch) obj;
    if (fDeploymentHost == null) {if (other.fDeploymentHost != null) return false;}
    else if (!fDeploymentHost.equals(other.fDeploymentHost)) return false;
    return true;
  }
  
  @Override
  public HostIpChangeQuerySpecification specification() {
    try {
    	return HostIpChangeQuerySpecification.instance();
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
  public static HostIpChangeMatch newEmptyMatch() {
    return new Mutable(null);
  }
  
  /**
   * Returns a mutable (partial) match.
   * Fields of the mutable match can be filled to create a partial match, usable as matcher input.
   * 
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return the new, mutable (partial) match object.
   * 
   */
  public static HostIpChangeMatch newMutableMatch(final DeploymentHost pDeploymentHost) {
    return new Mutable(pDeploymentHost);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pDeploymentHost the fixed value of pattern parameter deploymentHost, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public static HostIpChangeMatch newMatch(final DeploymentHost pDeploymentHost) {
    return new Immutable(pDeploymentHost);
  }
  
  private static final class Mutable extends HostIpChangeMatch {
    Mutable(final DeploymentHost pDeploymentHost) {
      super(pDeploymentHost);
    }
    
    @Override
    public boolean isMutable() {
      return true;
    }
  }
  
  private static final class Immutable extends HostIpChangeMatch {
    Immutable(final DeploymentHost pDeploymentHost) {
      super(pDeploymentHost);
    }
    
    @Override
    public boolean isMutable() {
      return false;
    }
  }
}
