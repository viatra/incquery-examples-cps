package org.eclipse.incquery.examples.cps.xform.m2t.listener;

import java.util.Set;

import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.ApplicationChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.BehaviorChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.DeploymentChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.HostChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.evm.api.ExecutionSchema;
import org.eclipse.incquery.runtime.evm.api.Job;
import org.eclipse.incquery.runtime.evm.api.RuleSpecification;
import org.eclipse.incquery.runtime.evm.specific.ExecutionSchemas;
import org.eclipse.incquery.runtime.evm.specific.Jobs;
import org.eclipse.incquery.runtime.evm.specific.Lifecycles;
import org.eclipse.incquery.runtime.evm.specific.Rules;
import org.eclipse.incquery.runtime.evm.specific.Schedulers;
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum;
import org.eclipse.incquery.runtime.evm.specific.job.EnableJob;
import org.eclipse.incquery.runtime.evm.specific.scheduler.UpdateCompleteBasedScheduler.UpdateCompleteBasedSchedulerFactory;
import org.eclipse.incquery.runtime.exception.IncQueryException;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;

public class ModelChangeListener implements IModelChangeListener {

	Set<Object> changesBetweenCheckpoints;
	Set<Object> changeAccumulator;

	@Override
	public synchronized void createCheckpoint() {
		changesBetweenCheckpoints = changeAccumulator;
		changeAccumulator = Sets.newHashSet();
	}

	@Override
	public ImmutableSet<Object> getChangedElementsSinceCheckpoint() {
		return ImmutableSet.copyOf(changeAccumulator); 
	}

	@Override
	public ImmutableSet<Object> getChangedElementsBetweenLastCheckpoints() {
		return ImmutableSet.copyOf(changesBetweenCheckpoints);
	}

	@Override
	public synchronized void startListening(Deployment deployment,
			IncQueryEngine engine) throws IncQueryException {

		this.changesBetweenCheckpoints = Sets.newHashSet();
		this.changeAccumulator = Sets.newHashSet();

		UpdateCompleteBasedSchedulerFactory schedulerFactory = Schedulers
				.getIQEngineSchedulerFactory(engine);
		ExecutionSchema executionSchema = ExecutionSchemas
				.createIncQueryExecutionSchema(engine, schedulerFactory);

		Set<Job<?>> allJobs = Sets.newHashSet();

		Set<Job<DeploymentChangeMatch>> deploymentJobs = Sets.newHashSet();
		createDeploymentJobs(deploymentJobs);
		allJobs.addAll(deploymentJobs);

		Set<Job<HostChangeMatch>> hostJobs = Sets.newHashSet();
		createHostJobs(hostJobs);
		allJobs.addAll(hostJobs);

		Set<Job<ApplicationChangeMatch>> applicationJobs = Sets.newHashSet();
		createApplicationJobs(applicationJobs);
		allJobs.addAll(applicationJobs);

		Set<Job<BehaviorChangeMatch>> behaviorJobs = Sets.newHashSet();
		createBehaviorJobs(behaviorJobs);
		allJobs.addAll(behaviorJobs);

		RuleSpecification<DeploymentChangeMatch> deploymentRules = Rules
				.newMatcherRuleSpecification(
						DeploymentChangeQuerySpecification.instance(),
						Lifecycles.getDefault(true, true), deploymentJobs);
		executionSchema.addRule(deploymentRules);

		RuleSpecification<HostChangeMatch> hostRules = Rules
				.newMatcherRuleSpecification(
						HostChangeQuerySpecification.instance(),
						Lifecycles.getDefault(true, true), hostJobs);
		executionSchema.addRule(hostRules);

		RuleSpecification<ApplicationChangeMatch> applicationRules = Rules
				.newMatcherRuleSpecification(
						ApplicationChangeQuerySpecification.instance(),
						Lifecycles.getDefault(true, true), applicationJobs);
		executionSchema.addRule(applicationRules);

		RuleSpecification<BehaviorChangeMatch> behaviorRules = Rules
				.newMatcherRuleSpecification(
						BehaviorChangeQuerySpecification.instance(),
						Lifecycles.getDefault(true, true), behaviorJobs);
		executionSchema.addRule(behaviorRules);

		executionSchema.startUnscheduledExecution();

		// Enable the jobs to listen to changes
		for (Job<?> job : allJobs) {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			EnableJob<ApplicationChangeMatch> enableJob = (EnableJob) job;
			enableJob.setEnabled(true);
		}

	}

	private void createHostJobs(Set<Job<HostChangeMatch>> jobs) {

		Job<HostChangeMatch> appear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.APPEARED,
				new IMatchProcessor<HostChangeMatch>() {

					@Override
					public void process(HostChangeMatch match) {
						changeAccumulator.add(match.getDeploymentHost());
						
					}

				});
		Job<HostChangeMatch> disappear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.DISAPPEARED,
				new IMatchProcessor<HostChangeMatch>() {

					@Override
					public void process(HostChangeMatch match) {
						changeAccumulator.add(match.getDeploymentHost());
						
					}

				});
		Job<HostChangeMatch> update = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.UPDATED,
				new IMatchProcessor<HostChangeMatch>() {

					@Override
					public void process(HostChangeMatch match) {
						changeAccumulator.add(match.getDeploymentHost());
						
					}

				});

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
	}

	private void createApplicationJobs(Set<Job<ApplicationChangeMatch>> jobs) {

		Job<ApplicationChangeMatch> appear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.APPEARED,
				new IMatchProcessor<ApplicationChangeMatch>() {

					@Override
					public void process(ApplicationChangeMatch match) {
						changeAccumulator.add(match.getApp());
						
					}

				});
		Job<ApplicationChangeMatch> disappear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.DISAPPEARED,
				new IMatchProcessor<ApplicationChangeMatch>() {

					@Override
					public void process(ApplicationChangeMatch match) {
						changeAccumulator.add(match.getApp());
						
					}

				});
		Job<ApplicationChangeMatch> update = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.UPDATED,
				new IMatchProcessor<ApplicationChangeMatch>() {

					@Override
					public void process(ApplicationChangeMatch match) {
						changeAccumulator.add(match.getApp());
						
					}

				});

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
	}

	private void createDeploymentJobs(Set<Job<DeploymentChangeMatch>> jobs) {

		Job<DeploymentChangeMatch> appear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.APPEARED,
				new IMatchProcessor<DeploymentChangeMatch>() {

					@Override
					public void process(DeploymentChangeMatch match) {
						changeAccumulator.add(match.getDeployment());
						
					}

				});
		Job<DeploymentChangeMatch> disappear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.DISAPPEARED,
				new IMatchProcessor<DeploymentChangeMatch>() {

					@Override
					public void process(DeploymentChangeMatch match) {
						changeAccumulator.add(match.getDeployment());
						
					}

				});
		Job<DeploymentChangeMatch> update = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.UPDATED,
				new IMatchProcessor<DeploymentChangeMatch>() {

					@Override
					public void process(DeploymentChangeMatch match) {
						changeAccumulator.add(match.getDeployment());
						
					}

				});

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
	}

	private void createBehaviorJobs(Set<Job<BehaviorChangeMatch>> jobs) {

		Job<BehaviorChangeMatch> appear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.APPEARED,
				new IMatchProcessor<BehaviorChangeMatch>() {

					@Override
					public void process(BehaviorChangeMatch match) {
						changeAccumulator.add((DeploymentElement) match
								.getBehavior());
						
					}

				});
		Job<BehaviorChangeMatch> disappear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.DISAPPEARED,
				new IMatchProcessor<BehaviorChangeMatch>() {

					@Override
					public void process(BehaviorChangeMatch match) {
						changeAccumulator.add((DeploymentElement) match
								.getBehavior());
						
					}

				});
		Job<BehaviorChangeMatch> update = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.UPDATED,
				new IMatchProcessor<BehaviorChangeMatch>() {

					@Override
					public void process(BehaviorChangeMatch match) {
						changeAccumulator.add(match.getBehavior());
						
					}

				});

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
	}


}
