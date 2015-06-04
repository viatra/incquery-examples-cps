package org.eclipse.incquery.examples.cps.xform.m2t.monitor;

import java.util.Arrays;
import java.util.List;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.util.DeploymentHostsChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.impl.BasePatternMatch;
import org.eclipse.incquery.runtime.exception.IncQueryException;

/**
 * Pattern-specific match representation of the org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostsChange pattern,
 * to be used in conjunction with {@link DeploymentHostsChangeMatcher}.
 * 
 * <p>Class fields correspond to parameters of the pattern. Fields with value null are considered unassigned.
 * Each instance is a (possibly partial) substitution of pattern parameters,
 * usable to represent a match of the pattern in the result of a query,
 * or to specify the bound (fixed) input parameters when issuing a query.
 * 
 * @see DeploymentHostsChangeMatcher
 * @see DeploymentHostsChangeProcessor
 * 
 */
@SuppressWarnings("all")
public abstract class DeploymentHostsChangeMatch extends BasePatternMatch {
  private Deployment fDeployment;
  
  private DeploymentHost fHost;
  
  private static List<String> parameterNames = makeImmutableList("deployment", "host");
  
  private DeploymentHostsChangeMatch(final Deployment pDeployment, final DeploymentHost pHost) {
    this.fDeployment = pDeployment;
    this.fHost = pHost;
  }
  
  @Override
  public Object get(final String parameterName) {
    if ("deployment".equals(parameterName)) return this.fDeployment;
    if ("host".equals(parameterName)) return this.fHost;
    return null;
  }
  
  public Deployment getDeployment() {
    return this.fDeployment;
  }
  
  public DeploymentHost getHost() {
    return this.fHost;
  }
  
  @Override
  public boolean set(final String parameterName, final Object newValue) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    if ("deployment".equals(parameterName) ) {
    	this.fDeployment = (org.eclipse.incquery.examples.cps.deployment.Deployment) newValue;
    	return true;
    }
    if ("host".equals(parameterName) ) {
    	this.fHost = (org.eclipse.incquery.examples.cps.deployment.DeploymentHost) newValue;
    	return true;
    }
    return false;
  }
  
  public void setDeployment(final Deployment pDeployment) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fDeployment = pDeployment;
  }
  
  public void setHost(final DeploymentHost pHost) {
    if (!isMutable()) throw new java.lang.UnsupportedOperationException();
    this.fHost = pHost;
  }
  
  @Override
  public String patternName() {
    return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostsChange";
  }
  
  @Override
  public List<String> parameterNames() {
    return DeploymentHostsChangeMatch.parameterNames;
  }
  
  @Override
  public Object[] toArray() {
    return new Object[]{fDeployment, fHost};
  }
  
  @Override
  public DeploymentHostsChangeMatch toImmutable() {
    return isMutable() ? newMatch(fDeployment, fHost) : this;
  }
  
  @Override
  public String prettyPrint() {
    StringBuilder result = new StringBuilder();
    result.append("\"deployment\"=" + prettyPrintValue(fDeployment) + ", ");
    
    result.append("\"host\"=" + prettyPrintValue(fHost)
    );
    return result.toString();
  }
  
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((fDeployment == null) ? 0 : fDeployment.hashCode());
    result = prime * result + ((fHost == null) ? 0 : fHost.hashCode());
    return result;
  }
  
  @Override
  public boolean equals(final Object obj) {
    if (this == obj)
    	return true;
    if (!(obj instanceof DeploymentHostsChangeMatch)) { // this should be infrequent
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
    DeploymentHostsChangeMatch other = (DeploymentHostsChangeMatch) obj;
    if (fDeployment == null) {if (other.fDeployment != null) return false;}
    else if (!fDeployment.equals(other.fDeployment)) return false;
    if (fHost == null) {if (other.fHost != null) return false;}
    else if (!fHost.equals(other.fHost)) return false;
    return true;
  }
  
  @Override
  public DeploymentHostsChangeQuerySpecification specification() {
    try {
    	return DeploymentHostsChangeQuerySpecification.instance();
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
  public static DeploymentHostsChangeMatch newEmptyMatch() {
    return new Mutable(null, null);
  }
  
  /**
   * Returns a mutable (partial) match.
   * Fields of the mutable match can be filled to create a partial match, usable as matcher input.
   * 
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @param pHost the fixed value of pattern parameter host, or null if not bound.
   * @return the new, mutable (partial) match object.
   * 
   */
  public static DeploymentHostsChangeMatch newMutableMatch(final Deployment pDeployment, final DeploymentHost pHost) {
    return new Mutable(pDeployment, pHost);
  }
  
  /**
   * Returns a new (partial) match.
   * This can be used e.g. to call the matcher with a partial match.
   * <p>The returned match will be immutable. Use {@link #newEmptyMatch()} to obtain a mutable match object.
   * @param pDeployment the fixed value of pattern parameter deployment, or null if not bound.
   * @param pHost the fixed value of pattern parameter host, or null if not bound.
   * @return the (partial) match object.
   * 
   */
  public static DeploymentHostsChangeMatch newMatch(final Deployment pDeployment, final DeploymentHost pHost) {
    return new Immutable(pDeployment, pHost);
  }
  
  private static final class Mutable extends DeploymentHostsChangeMatch {
    Mutable(final Deployment pDeployment, final DeploymentHost pHost) {
      super(pDeployment, pHost);
    }
    
    @Override
    public boolean isMutable() {
      return true;
    }
  }
  
  private static final class Immutable extends DeploymentHostsChangeMatch {
    Immutable(final Deployment pDeployment, final DeploymentHost pHost) {
      super(pDeployment, pHost);
    }
    
    @Override
    public boolean isMutable() {
      return false;
    }
  }
}
