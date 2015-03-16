package org.eclipse.incquery.examples.cps.xform.m2t.util.genericmonitor;

import java.util.Collection;
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
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.Sets;

@SuppressWarnings("unchecked")
public class ChangeMonitor extends IChangeMonitor {
	
	/*
	 * TODO specification helyett rule-ok tárolása
	 * rule eltávolitás 
	 * 
	 * 
	 * */

	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> appearBetweenCheckpoints;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> updateBetweenCheckpoints;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> disappearBetweenCheckpoints;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> appearAccumulator;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> updateAccumulator;
	private Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> disappearAccumulator;
	private Set<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>> specifications;

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

		specifications = new HashSet<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>>();
		specifications
				.addAll((Collection<? extends IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>>) engine
						.getRegisteredQuerySpecifications());
		deploymentBetweenCheckpointsChanged = false;
		changed = false;
		started = false;

		UpdateCompleteBasedSchedulerFactory schedulerFactory = Schedulers
				.getIQEngineSchedulerFactory(engine);
		executionSchema = ExecutionSchemas.createIncQueryExecutionSchema(
				engine, schedulerFactory);

	}

	public void addSpecification(IQuerySpecification<?> spec) {
		specifications
				.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) spec);
		if (started) {
			RuleSpecification<IPatternMatch> applicationRule = Rules
					.newMatcherRuleSpecification(
							(IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) spec,
							Lifecycles.getDefault(true, true),
							createDefaultProcessorJobs());
			executionSchema.addRule(applicationRule);
			Multimap<ActivationState, Job<IPatternMatch>> jobs = applicationRule
					.getJobs();
			for (ActivationState state : jobs.keySet()) {
				for (Job<?> job : jobs.get(state)) {
					EnableJob<?> enableJob = (EnableJob<?>) job;
					enableJob.setEnabled(true);
				}
			}
		}
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

		Set<Job<?>> allJobs = Sets.newHashSet();

		Map<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, Set<Job<IPatternMatch>>> querySpecificationsToJobs = getElementChangeQuerySpecifications();

		for (IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> querySpec : querySpecificationsToJobs
				.keySet()) {
			registerJobsForPattern(executionSchema,
					querySpecificationsToJobs.get(querySpec), querySpec);
		}
		Collection<Set<Job<IPatternMatch>>> registeredJobs = querySpecificationsToJobs
				.values();
		for (Set<Job<IPatternMatch>> elementJobs : registeredJobs) {
			allJobs.addAll(elementJobs);
		}
		executionSchema.startUnscheduledExecution();
		// Enable the jobs to listen to changes
		for (Job<?> job : allJobs) {
			EnableJob<?> enableJob = (EnableJob<?>) job;
			enableJob.setEnabled(true);
		}
		started = true;
	}

	
	private void registerJobsForPattern(
			ExecutionSchema executionSchema,
			Set<Job<IPatternMatch>> deploymentElementJobs,
			IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> changeQuerySpecification) {
		RuleSpecification<IPatternMatch> applicationRule = Rules
				.newMatcherRuleSpecification(changeQuerySpecification,
						Lifecycles.getDefault(true, true),
						deploymentElementJobs);
		executionSchema.addRule(applicationRule);
	}

	//todo queryspecification paraméter
	private Map<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, Set<Job<IPatternMatch>>> getElementChangeQuerySpecifications()
			throws IncQueryException {
		Map<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, Set<Job<IPatternMatch>>> querySpecifications = Maps
				.newHashMap();
		for (IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> iQuerySpecification : specifications) {
			querySpecifications.put(iQuerySpecification,
					createDefaultProcessorJobs());
		}

		return querySpecifications;
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

		return createElementJobs(appearProcessor, disappearProcessor,
				updateProcessor);
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
			if(updateElements.contains(eObject))
				updateElements.remove(eObject);
			if(appearElements.contains(eObject))
				appearElements.remove(eObject);
		}

		disappearElements.addAll(objects);
	}

	private Set<Job<IPatternMatch>> createElementJobs(
			IMatchProcessor<IPatternMatch> appearProcessor,
			IMatchProcessor<IPatternMatch> disappearProcessor,
			IMatchProcessor<IPatternMatch> updateProcessor) {
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

		return jobs;
	}

}
