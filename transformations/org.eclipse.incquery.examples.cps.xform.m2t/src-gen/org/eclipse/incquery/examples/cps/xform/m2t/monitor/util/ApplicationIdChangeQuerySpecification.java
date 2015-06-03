package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationIdChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationIdChangeMatcher;
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
 * A pattern-specific query specification that can instantiate ApplicationIdChangeMatcher in a type-safe way.
 * 
 * @see ApplicationIdChangeMatcher
 * @see ApplicationIdChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class ApplicationIdChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<ApplicationIdChangeMatcher> {
  private ApplicationIdChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static ApplicationIdChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected ApplicationIdChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return ApplicationIdChangeMatcher.on(engine);
  }
  
  @Override
  public ApplicationIdChangeMatch newEmptyMatch() {
    return ApplicationIdChangeMatch.newEmptyMatch();
  }
  
  @Override
  public ApplicationIdChangeMatch newMatch(final Object... parameters) {
    return ApplicationIdChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentApplication) parameters[0]);
  }
  
  private static class LazyHolder {
    private final static ApplicationIdChangeQuerySpecification INSTANCE = make();
    
    public static ApplicationIdChangeQuerySpecification make() {
      return new ApplicationIdChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static ApplicationIdChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.applicationIdChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("app");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("app", "org.eclipse.incquery.examples.cps.deployment.DeploymentApplication"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_app = body.getOrCreateVariableByName("app");
      	PVariable var___0_ = body.getOrCreateVariableByName("_<0>");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_app, "app")
      	));
      	new TypeConstraint(body, new FlatTuple(var_app), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentApplication")));
      	new TypeConstraint(body, new FlatTuple(var_app), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentApplication")));
      	new TypeConstraint(body, new FlatTuple(var_app, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentApplication", "id")));
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
