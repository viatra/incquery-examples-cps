package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.BehaviorChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.BehaviorChangeMatcher;
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
 * A pattern-specific query specification that can instantiate BehaviorChangeMatcher in a type-safe way.
 * 
 * @see BehaviorChangeMatcher
 * @see BehaviorChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class BehaviorChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<BehaviorChangeMatcher> {
  private BehaviorChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static BehaviorChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected BehaviorChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return BehaviorChangeMatcher.on(engine);
  }
  
  @Override
  public BehaviorChangeMatch newEmptyMatch() {
    return BehaviorChangeMatch.newEmptyMatch();
  }
  
  @Override
  public BehaviorChangeMatch newMatch(final Object... parameters) {
    return BehaviorChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) parameters[0]);
  }
  
  private static class LazyHolder {
    private final static BehaviorChangeQuerySpecification INSTANCE = make();
    
    public static BehaviorChangeQuerySpecification make() {
      return new BehaviorChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static BehaviorChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.behaviorChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("behavior");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("behavior", "org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_behavior = body.getOrCreateVariableByName("behavior");
      	PVariable var___0_ = body.getOrCreateVariableByName("_<0>");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_behavior, "behavior")
      	));
      	new TypeConstraint(body, new FlatTuple(var_behavior), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior")));
      	new TypeConstraint(body, new FlatTuple(var_behavior), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior")));
      	new TypeConstraint(body, new FlatTuple(var_behavior, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior", "states")));
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
