package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostIpChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostIpChangeMatcher;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.impl.BaseGeneratedEMFPQuery;
import org.eclipse.incquery.runtime.api.impl.BaseGeneratedEMFQuerySpecification;
import org.eclipse.incquery.runtime.emf.types.EClassTransitiveInstancesKey;
import org.eclipse.incquery.runtime.emf.types.EStructuralFeatureInstancesKey;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.incquery.runtime.matchers.psystem.PBody;
import org.eclipse.incquery.runtime.matchers.psystem.PVariable;
import org.eclipse.incquery.runtime.matchers.psystem.basicdeferred.Equality;
import org.eclipse.incquery.runtime.matchers.psystem.basicdeferred.ExportedParameter;
import org.eclipse.incquery.runtime.matchers.psystem.basicenumerables.TypeConstraint;
import org.eclipse.incquery.runtime.matchers.psystem.queries.PParameter;
import org.eclipse.incquery.runtime.matchers.psystem.queries.QueryInitializationException;
import org.eclipse.incquery.runtime.matchers.tuple.FlatTuple;

/**
 * A pattern-specific query specification that can instantiate HostIpChangeMatcher in a type-safe way.
 * 
 * @see HostIpChangeMatcher
 * @see HostIpChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class HostIpChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<HostIpChangeMatcher> {
  private HostIpChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static HostIpChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected HostIpChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return HostIpChangeMatcher.on(engine);
  }
  
  @Override
  public HostIpChangeMatch newEmptyMatch() {
    return HostIpChangeMatch.newEmptyMatch();
  }
  
  @Override
  public HostIpChangeMatch newMatch(final Object... parameters) {
    return HostIpChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentHost) parameters[0]);
  }
  
  private static class LazyHolder {
    private final static HostIpChangeQuerySpecification INSTANCE = make();
    
    public static HostIpChangeQuerySpecification make() {
      return new HostIpChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static HostIpChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.hostIpChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("deploymentHost");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("deploymentHost", "org.eclipse.incquery.examples.cps.deployment.DeploymentHost"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_deploymentHost = body.getOrCreateVariableByName("deploymentHost");
      	PVariable var___0_ = body.getOrCreateVariableByName("_<0>");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_deploymentHost, "deploymentHost")
      	));
      	new TypeConstraint(body, new FlatTuple(var_deploymentHost), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentHost")));
      	new TypeConstraint(body, new FlatTuple(var_deploymentHost), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentHost")));
      	new TypeConstraint(body, new FlatTuple(var_deploymentHost, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentHost", "ip")));
      	new Equality(body, var__virtual_0_, var___0_);
      	bodies.add(body);
      }
      	// to silence compiler error
      	if (false) throw new IncQueryException("Never", "happens");
      } catch (IncQueryException ex) {
      	throw processDependencyException(ex);
      }
      return bodies;
    }
  }
}
