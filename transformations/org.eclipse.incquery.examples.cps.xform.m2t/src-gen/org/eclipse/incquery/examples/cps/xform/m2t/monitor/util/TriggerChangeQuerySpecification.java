package org.eclipse.incquery.examples.cps.xform.m2t.monitor.util;

import com.google.common.collect.Sets;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TriggerChangeMatch;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.TriggerChangeMatcher;
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
 * A pattern-specific query specification that can instantiate TriggerChangeMatcher in a type-safe way.
 * 
 * @see TriggerChangeMatcher
 * @see TriggerChangeMatch
 * 
 */
@SuppressWarnings("all")
public final class TriggerChangeQuerySpecification extends BaseGeneratedEMFQuerySpecification<TriggerChangeMatcher> {
  private TriggerChangeQuerySpecification() {
    super(GeneratedPQuery.INSTANCE);
  }
  
  /**
   * @return the singleton instance of the query specification
   * @throws IncQueryException if the pattern definition could not be loaded
   * 
   */
  public static TriggerChangeQuerySpecification instance() throws IncQueryException {
    try{
    	return LazyHolder.INSTANCE;
    } catch (ExceptionInInitializerError err) {
    	throw processInitializerError(err);
    }
  }
  
  @Override
  protected TriggerChangeMatcher instantiate(final IncQueryEngine engine) throws IncQueryException {
    return TriggerChangeMatcher.on(engine);
  }
  
  @Override
  public TriggerChangeMatch newEmptyMatch() {
    return TriggerChangeMatch.newEmptyMatch();
  }
  
  @Override
  public TriggerChangeMatch newMatch(final Object... parameters) {
    return TriggerChangeMatch.newMatch((org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior) parameters[0], (org.eclipse.incquery.examples.cps.deployment.BehaviorTransition) parameters[1]);
  }
  
  private static class LazyHolder {
    private final static TriggerChangeQuerySpecification INSTANCE = make();
    
    public static TriggerChangeQuerySpecification make() {
      return new TriggerChangeQuerySpecification();					
    }
  }
  
  private static class GeneratedPQuery extends BaseGeneratedEMFPQuery {
    private final static TriggerChangeQuerySpecification.GeneratedPQuery INSTANCE = new GeneratedPQuery();
    
    @Override
    public String getFullyQualifiedName() {
      return "org.eclipse.incquery.examples.cps.xform.m2t.monitor.triggerChange";
    }
    
    @Override
    public List<String> getParameterNames() {
      return Arrays.asList("behavior","transition");
    }
    
    @Override
    public List<PParameter> getParameters() {
      return Arrays.asList(new PParameter("behavior", "org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior"),new PParameter("transition", "org.eclipse.incquery.examples.cps.deployment.BehaviorTransition"));
    }
    
    @Override
    public Set<PBody> doGetContainedBodies() throws QueryInitializationException {
      Set<PBody> bodies = Sets.newLinkedHashSet();
      try {
      {
      	PBody body = new PBody(this);
      	PVariable var_behavior = body.getOrCreateVariableByName("behavior");
      	PVariable var_transition = body.getOrCreateVariableByName("transition");
      	PVariable var__virtual_0_ = body.getOrCreateVariableByName(".virtual{0}");
      	PVariable var___0_ = body.getOrCreateVariableByName("_<0>");
      	PVariable var__virtual_1_ = body.getOrCreateVariableByName(".virtual{1}");
      	body.setExportedParameters(Arrays.<ExportedParameter>asList(
      		new ExportedParameter(body, var_behavior, "behavior"),
      				
      		new ExportedParameter(body, var_transition, "transition")
      	));
      	new TypeConstraint(body, new FlatTuple(var_behavior), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior")));
      	new TypeConstraint(body, new FlatTuple(var_behavior), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior")));
      	new TypeConstraint(body, new FlatTuple(var_behavior, var__virtual_0_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "DeploymentBehavior", "transitions")));
      	new Equality(body, var__virtual_0_, var_transition);
      	new TypeConstraint(body, new FlatTuple(var_transition), new EClassTransitiveInstancesKey((EClass)getClassifierLiteral("http://org.eclipse.incquery/model/deployment", "BehaviorTransition")));
      	new TypeConstraint(body, new FlatTuple(var_transition, var__virtual_1_), new EStructuralFeatureInstancesKey(getFeatureLiteral("http://org.eclipse.incquery/model/deployment", "BehaviorTransition", "trigger")));
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
