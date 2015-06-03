package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostsChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentHostsChangeMatcher;
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
 * A pattern-specific query specification that can instantiate DeploymentHostsChangeMatcher in a type-safe way.
 * 
 * @see DeploymentHostsChangeMatcher
 * @see DeploymentHostsChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class DeploymentHostsChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<DeploymentHostsChangeMatcher> {
  private DeploymentHostsChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static DeploymentHostsChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected DeploymentHostsChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return DeploymentHostsChangeMatcher.on(engine);
  }
  
  @Override
  public DeploymentHostsChangeMatch newEmptyMatch() {
    return DeploymentHostsChangeMatch.newEmptyMatch();
  }
  
  @Override
  public DeploymentHostsChangeMatch newMatch(final Object... parameters) {
    return DeploymentHostsChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.Deployment) parameters[0], (org.eclipse.incquery.examples.cps.deployment.DeploymentHost) parameters[1]);
  }
  
  private static class LazyHolder {
    private final static DeploymentHostsChangeQuerySpecification INSTANCE = make();
    
    public static DeploymentHostsChangeQuerySpecification make() {
      return new DeploymentHostsChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static DeploymentHostsChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.deploymentHostsChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("deployment","host");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("deployment", "org.eclipse.incquery.examples.cps.deployment.Deployment"),new PParameter("host", "org.eclipse.incquery.examples.cps.deployment.DeploymentHost"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_deployment = body.getOrCreateVariableByName("deployment");
      	PVariable var_host = body.getOrCreateVariableByName("host");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_deployment, "deployment"),
      				
      		new ExportedParameter(body, var_host, "host")
      	));
      	new TypeConstraint(body, new FlatTuple(var_deployment), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "Deployment")));
      	new TypeConstraint(body, new FlatTuple(var_deployment), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "Deployment")));
      	new TypeConstraint(body, new FlatTuple(var_deployment, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "Deployment", "hosts")));
      	new Equality(body, var__virtual_0_, var_host);
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
