package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostApplicationsChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.HostApplicationsChangeMatcher;
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
 * A pattern-specific query specification that can instantiate HostApplicationsChangeMatcher in a type-safe way.
 * 
 * @see HostApplicationsChangeMatcher
 * @see HostApplicationsChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class HostApplicationsChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<HostApplicationsChangeMatcher> {
  private HostApplicationsChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static HostApplicationsChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected HostApplicationsChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return HostApplicationsChangeMatcher.on(engine);
  }
  
  @Override
  public HostApplicationsChangeMatch newEmptyMatch() {
    return HostApplicationsChangeMatch.newEmptyMatch();
  }
  
  @Override
  public HostApplicationsChangeMatch newMatch(final Object... parameters) {
    return HostApplicationsChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentHost) parameters[0]);
  }
  
  private static class LazyHolder {
    private final static HostApplicationsChangeQuerySpecification INSTANCE = make();
    
    public static HostApplicationsChangeQuerySpecification make() {
      return new HostApplicationsChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static HostApplicationsChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.hostApplicationsChange";
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
      	new TypeConstraint(body, new FlatTuple(var_deploymentHost, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentHost", "applications")));
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
