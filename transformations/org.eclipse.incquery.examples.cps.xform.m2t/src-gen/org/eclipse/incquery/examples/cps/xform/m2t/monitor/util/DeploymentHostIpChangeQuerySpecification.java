package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostIpChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostIpChangeMatcher;
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
 * A pattern-specific query specification that can instantiate DeploymentHostIpChangeMatcher in a type-safe way.
 * 
 * @see DeploymentHostIpChangeMatcher
 * @see DeploymentHostIpChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class DeploymentHostIpChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<DeploymentHostIpChangeMatcher> {
  private DeploymentHostIpChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static DeploymentHostIpChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected DeploymentHostIpChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return DeploymentHostIpChangeMatcher.on(engine);
  }
  
  @Override
  public DeploymentHostIpChangeMatch newEmptyMatch() {
    return DeploymentHostIpChangeMatch.newEmptyMatch();
  }
  
  @Override
  public DeploymentHostIpChangeMatch newMatch(final Object... parameters) {
    return DeploymentHostIpChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.Deployment) parameters[0]);
  }
  
  private static class LazyHolder {
    private final static DeploymentHostIpChangeQuerySpecification INSTANCE = make();
    
    public static DeploymentHostIpChangeQuerySpecification make() {
      return new DeploymentHostIpChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static DeploymentHostIpChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostIpChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("deployment");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("deployment", "org.eclipse.incquery.examples.cps.deployment.Deployment"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_deployment = body.getOrCreateVariableByName("deployment");
      	PVariable var___0_ = body.getOrCreateVariableByName("_<0>");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	PVariable var__virtual_1_ = body.getOrCreateVariableByName(".virtual{1}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_deployment, "deployment")
      	));
      	new TypeConstraint(body, new FlatTuple(var_deployment), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "Deployment")));
      	new TypeConstraint(body, new FlatTuple(var_deployment), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "Deployment")));
      	new TypeConstraint(body, new FlatTuple(var_deployment, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "Deployment", "hosts")));
      	new TypeConstraint(body, new FlatTuple(var__virtual_0_, var__virtual_1_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentHost", "ip")));
      	new Equality(body, var__virtual_1_, var___0_);
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
