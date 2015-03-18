package org.eclipse.incquery.examples.cps.xform.m2t.util.genericmonitor;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.IncQueryMatcher;
import org.eclipse.incquery.runtime.evm.api.ExecutionSchema;
import org.eclipse.incquery.runtime.evm.api.Job;
import org.eclipse.incquery.runtime.evm.api.RuleSpecification;
import org.eclipse.incquery.runtime.evm.api.event.ActivationState;
import org.eclipse.incquery.runtime.evm.specific.ExecutionSchemas;
import org.eclipse.incquery.runtime.evm.specific.Jobs;
import org.eclipse.incquery.runtime.evm.specific.Lifecycles;
import org.eclipse.incquery.runtime.evm.specific.Rules;
import org.eclipse.incquery.runtime.evm.specific.Schedulers;
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum;
import org.eclipse.incquery.runtime.evm.specific.job.EnableJob;
import org.eclipse.incquery.runtime.evm.specific.job.StatelessJob;
import org.eclipse.incquery.runtime.evm.specific.scheduler.UpdateCompleteBasedScheduler.UpdateCompleteBasedSchedulerFactory;
import org.eclipse.incquery.runtime.exception.IncQueryException;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import com.google.common.collect.Sets;

@SuppressWarnings("unchecked")
public class ChangeMonitor extends IChangeMonitor {
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> appearBetweenCheckpoints;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> updateBetweenCheckpoints;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> disappearBetweenCheckpoints;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> appearAccumulator;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> updateAccumulator;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> disappearAccumulator;
	private Set<RuleSpecification<IPatternMatch>> rules;
	private Map<IQuerySpecification<?> ,RuleSpecification<IPatternMatch>> specs;
	private Set<Job<?>> allJobs;

	private boolean deploymentBetweenCheckpointsChanged;
	private boolean changed;
	private boolean started;
	private ExecutionSchema executionSchema;

	public ChangeMonitor(IncQueryEngine engine) {
		super(engine);
		this.appearBetweenCheckpoints = ArrayListMultimap.create();
		this.updateBetweenCheckpoints = ArrayListMultimap.create();
		this.disappearBetweenCheckpoints = ArrayListMultimap.create();
		this.appearAccumulator = ArrayListMultimap.create();
		this.updateAccumulator = ArrayListMultimap.create();
		this.disappearAccumulator = ArrayListMultimap.create();

		allJobs = new HashSet<Job<?>>();
		rules = new HashSet<RuleSpecification<IPatternMatch>>();
		specs = new HashMap<IQuerySpecification<?>, RuleSpecification<IPatternMatch>>();
		deploymentBetweenCheckpointsChanged = false;
		changed = false;
		started = false;

		UpdateCompleteBasedSchedulerFactory schedulerFactory = Schedulers
				.getIQEngineSchedulerFactory(engine);
		executionSchema = ExecutionSchemas.createIncQueryExecutionSchema(
				engine, schedulerFactory);

	}
	
	
	public void addRule(RuleSpecification<IPatternMatch> rule) {
		rules.add(rule);
		Multimap<ActivationState, Job<IPatternMatch>> jobs = rule.getJobs();
		if (started) {
			executionSchema.addRule(rule);
		}
		for (ActivationState state : jobs.keySet()) {
			for (Job<?> job : jobs.get(state)) {
				if (started) {
				EnableJob<?> enableJob = (EnableJob<?>) job;
				enableJob.setEnabled(true);
				} else {
					allJobs.add(job);
				}
			}
		}
	}

	public void addRule(IQuerySpecification<?> spec) {
		RuleSpecification<IPatternMatch> rule = Rules
				.newMatcherRuleSpecification(
						(IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) spec,
						Lifecycles.getDefault(true, true),
						createDefaultProcessorJobs());
		specs.put(spec, rule);
		addRule(rule);
	}
	
	public void removeRule(RuleSpecification<IPatternMatch> rule){
		rules.remove(rule);
		executionSchema.removeRule(rule);
	}
	
	public void removeRule(IQuerySpecification<?> spec){
		RuleSpecification<IPatternMatch> ruleSpecification = specs.get(spec);
		rules.remove(ruleSpecification);
		specs.remove(spec);
		executionSchema.removeRule(ruleSpecification);
	}

	@Override
	public ChangeDelta createCheckpoint() {
		appearBetweenCheckpoints = appearAccumulator;
		updateBetweenCheckpoints = updateAccumulator;
		disappearBetweenCheckpoints = disappearAccumulator;
		appearAccumulator = ArrayListMultimap.create();
		updateAccumulator = ArrayListMultimap.create();
		disappearAccumulator = ArrayListMultimap.create();
		deploymentBetweenCheckpointsChanged = changed;

		return new ChangeDelta(appearBetweenCheckpoints,
				updateBetweenCheckpoints, disappearBetweenCheckpoints,
				deploymentBetweenCheckpointsChanged);
	}

	@Override
	public ChangeDelta getDeltaSinceLastCheckpoint() {
		return new ChangeDelta(appearAccumulator, updateAccumulator,
				disappearAccumulator, changed);
	}

	@Override
	public void startMonitoring() throws IncQueryException {

		for (RuleSpecification<IPatternMatch> rule : rules) {
			executionSchema.addRule(rule);
		}
		
		executionSchema.startUnscheduledExecution();
		// Enable the jobs to listen to changes
		for (Job<?> job : allJobs) {
			EnableJob<?> enableJob = (EnableJob<?>) job;
			enableJob.setEnabled(true);
		}
		started = true;
	}

	protected Set<Job<IPatternMatch>> createDefaultProcessorJobs() {
		IMatchProcessor<IPatternMatch> appearProcessor = new IMatchProcessor<IPatternMatch>() {
			@Override
			public void process(IPatternMatch match) {

				registerAppear(match);
			}
		};
		IMatchProcessor<IPatternMatch> disappearProcessor = new IMatchProcessor<IPatternMatch>() {
			@Override
			public void process(IPatternMatch match) {

				registerDisappear(match);

			}
		};
		IMatchProcessor<IPatternMatch> updateProcessor = new IMatchProcessor<IPatternMatch>() {
			@Override
			public void process(IPatternMatch match) {
				registerUpdate(match);
			}
		};

		Set<Job<IPatternMatch>> jobs = Sets.newHashSet();
		Job<IPatternMatch> appear = new StatelessJob<IPatternMatch>(
				IncQueryActivationStateEnum.APPEARED, appearProcessor);
		Job<IPatternMatch> disappear = new StatelessJob<IPatternMatch>(
				IncQueryActivationStateEnum.DISAPPEARED, disappearProcessor);
		Job<IPatternMatch> update = new StatelessJob<IPatternMatch>(
				IncQueryActivationStateEnum.UPDATED, updateProcessor);

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
		allJobs.addAll(jobs);
		return jobs;
	}

	private void registerUpdate(IPatternMatch match) {
		IQuerySpecification<? extends IncQueryMatcher<? extends IPatternMatch>> specification = match
				.specification();
		Set<EObject> objects = new HashSet<EObject>();
		int i = 0;
		while (match.get(i) != null) {
			objects.add((EObject) match.get(i));
			i++;
		}
		Collection<EObject> updateElements = updateAccumulator
				.get((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) specification);
		updateElements.addAll(objects);
	}

	private void registerAppear(IPatternMatch match) {
		IQuerySpecification<? extends IncQueryMatcher<? extends IPatternMatch>> specification = match
				.specification();
		Set<EObject> objects = new HashSet<EObject>();
		int i = 0;
		while (match.get(i) != null) {
			objects.add((EObject) match.get(i));
			i++;
		}
		Collection<EObject> appearElements = appearAccumulator
				.get((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) specification);
		appearElements.addAll(objects);
	}

	private void registerDisappear(IPatternMatch match) {
		IQuerySpecification<? extends IncQueryMatcher<? extends IPatternMatch>> specification = match
				.specification();
		Set<EObject> objects = new HashSet<EObject>();
		int i = 0;
		while (match.get(i) != null) {
			objects.add((EObject) match.get(i));
			i++;
		}
		Collection<EObject> appearElements = appearAccumulator
				.get((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) specification);
		Collection<EObject> updateElements = updateAccumulator
				.get((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) specification);
		Collection<EObject> disappearElements = disappearAccumulator
				.get((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) specification);
		for (EObject eObject : objects) {
			if (updateElements.contains(eObject))
				updateElements.remove(eObject);
			if (appearElements.contains(eObject))
				appearElements.remove(eObject);
		}
		disappearElements.addAll(objects);
	}
}
