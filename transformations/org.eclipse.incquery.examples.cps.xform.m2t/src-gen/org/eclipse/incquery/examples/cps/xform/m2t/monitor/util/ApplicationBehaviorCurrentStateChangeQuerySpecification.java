package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationBehaviorCurrentStateChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.ApplicationBehaviorCurrentStateChangeMatcher;
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
 * A pattern-specific query specification that can instantiate ApplicationBehaviorCurrentStateChangeMatcher in a type-safe way.
 * 
 * @see ApplicationBehaviorCurrentStateChangeMatcher
 * @see ApplicationBehaviorCurrentStateChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class ApplicationBehaviorCurrentStateChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<ApplicationBehaviorCurrentStateChangeMatcher> {
  private ApplicationBehaviorCurrentStateChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static ApplicationBehaviorCurrentStateChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected ApplicationBehaviorCurrentStateChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return ApplicationBehaviorCurrentStateChangeMatcher.on(engine);
  }
  
  @Override
  public ApplicationBehaviorCurrentStateChangeMatch newEmptyMatch() {
    return ApplicationBehaviorCurrentStateChangeMatch.newEmptyMatch();
  }
  
  @Override
  public ApplicationBehaviorCurrentStateChangeMatch newMatch(final Object... parameters) {
    return ApplicationBehaviorCurrentStateChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentApplication) parameters[0], (org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) parameters[1]);
  }
  
  private static class LazyHolder {
    private final static ApplicationBehaviorCurrentStateChangeQuerySpecification INSTANCE = make();
    
    public static ApplicationBehaviorCurrentStateChangeQuerySpecification make() {
      return new ApplicationBehaviorCurrentStateChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static ApplicationBehaviorCurrentStateChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.applicationBehaviorCurrentStateChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("app","beh");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("app", "org.eclipse.incquery.examples.cps.deployment.DeploymentApplication"),new PParameter("beh", "org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_app = body.getOrCreateVariableByName("app");
      	PVariable var_beh = body.getOrCreateVariableByName("beh");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	PVariable var___0_ = body.getOrCreateVariableByName("_<0>");
      	PVariable var__virtual_1_ = body.getOrCreateVariableByName(".virtual{1}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_app, "app"),
      				
      		new ExportedParameter(body, var_beh, "beh")
      	));
      	new TypeConstraint(body, new FlatTuple(var_app), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentApplication")));
      	new TypeConstraint(body, new FlatTuple(var_app), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentApplication")));
      	new TypeConstraint(body, new FlatTuple(var_app, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentApplication", "behavior")));
      	new Equality(body, var__virtual_0_, var_beh);
      	new TypeConstraint(body, new FlatTuple(var_beh), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior")));
      	new TypeConstraint(body, new FlatTuple(var_beh, var__virtual_1_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior", "current")));
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
