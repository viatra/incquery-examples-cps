package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Arrays;
import java.util.List;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.DeploymentHostIpChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.impl.BasePatternMatch;
import org.eclipse.incquery.runtime.exception.IncQueryException;

/**
 * Pattern-specific match representation of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostIpChange pattern,
 * to be used in conjunction with {@link DeploymentHostIpChangeMatcher}.
 * 
 * <p>Class fields correspond to parameters of the pattern. Fields with value null are considered unassigned.
 * Each instance is a (possibly partial) substitution of pattern parameters,
 * usable to represent a match of the pattern in the result of a query,
 * or to specify the bound (fixed) input parameters when issuing a query.
 * 
 * @see DeploymentHostIpChangeMatcher
 * @see DeploymentHostIpChangeProcessor
 * 
 */
@SuppressWarnings("all")
public abstract class DeploymentHostIpChangeMatch extends BasePatternMatch {
  private Deployment fDeployment;
  
  private static List<String> parameterNames = makeImmutableList("deployment");
  
  private DeploymentHostIpChangeMatch(final Deployment pDeployment) {
    this.fDeployment = pDeployment;
  }
  
  @Override
  public Object get(final String parameterName) {
    if ("deployment".equals(parameterName)) return this.fDeployment;
    return null;
  }
  
  public Deployment getDeployment() {
    return this.fDeployment;
  }
  
  @Override
  public boolean set(final String parameterName, final Object newValue) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    if ("deployment".equals(parameterName) ) {
    	this.fDeployment = (org.eclipse.incquery.examples.cps.deployment.Deployment) newValue;
    	return true;
    }
    return false;
  }
  
  public void setDeployment(final Deployment pDeployment) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fDeployment = pDeployment;
  }
  
  @Override
  public String patternName() {
    return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostIpChange";
  }
  
  @Override
  public List<String> parameterNames() {
    return DeploymentHostIpChangeMatch.parameterNames;
  }
  
  @Override
  public Object[] toArray() {
    return new Object[]{fDeployment};
  }
  
  @Override
  public DeploymentHostIpChangeMatch toImmutable() {
    return isMutable() ? newMatch(fDeployment) : this;
  }
  
  @Override
  public String prettyPrint() {
    StringBuilder result = new StringBuilder();
    result.append("\"deployment\"=" + prettyPrintValue(fDeployment)
    );
    return result.toString();
  }
  
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((fDeployment == null) ? 0 : fDeployment.hashCode());
    return result;
  }
  
  @Override
  public boolean equals(final Object obj) {
    if (this == obj)
    	return true;
    if (!(obj instanceof DeploymentHostIpChangeMatch)) { // this should be infrequent
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
    DeploymentHostIpChangeMatch other = (DeploymentHostIpChangeMatch) obj;
    if (fDeployment == null) {if (other.fDeployment != null) return false;}
    else if (!fDeployment.equals(other.fDeployment)) return false;
    return true;
  }
  
  @Override
  public DeploymentHostIpChangeQuerySpecification specification() {
    try {
    	return DeploymentHostIpChangeQuerySpecification.instance();
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
  public static DeploymentHostIpChangeMatch newEmptyMatch() {
    return new Mutable(null);
  }
  
  /**
   * Returns a mutable (partial) match.
   * Fields of the mutable match can be filled to create a partial match, usable as matcher input.
   * 
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return the new, mutable (partial) match object.
   * 
   */
  public static DeploymentHostIpChangeMatch newMutableMatch(final Deployment pDeployment) {
    return new Mutable(pDeployment);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public static DeploymentHostIpChangeMatch newMatch(final Deployment pDeployment) {
    return new Immutable(pDeployment);
  }
  
  private static final class Mutable extends DeploymentHostIpChangeMatch {
    Mutable(final Deployment pDeployment) {
      super(pDeployment);
    }
    
    @Override
    public boolean isMutable() {
      return true;
    }
  }
  
  private static final class Immutable extends DeploymentHostIpChangeMatch {
    Immutable(final Deployment pDeployment) {
      super(pDeployment);
    }
    
    @Override
    public boolean isMutable() {
      return false;
    }
  }
}
