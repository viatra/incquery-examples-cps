package org.eclipse.incquery.examples.cps.xform.m2t.listener;

import java.util.List;
import java.util.Set;

import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.ApplicationBehaviorChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.ApplicationIdChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.BehaviorChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.DeploymentHostIpChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.DeploymentHostsChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.HostApplicationsChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.HostIpChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.TransitionChangeQuerySpecification;
import org.eclipse.incquery.examples.cps.xform.m2t.listener.util.TriggerChangeQuerySpecification;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.api.IncQueryMatcher;
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

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;

@SuppressWarnings("unchecked")
public class DeploymentChangeMonitor implements IDeploymentChangeMonitor {

	Set<DeploymentElement> appearBetweenCheckpoints;
	Set<DeploymentElement> updateBetweenCheckpoints;
	Set<DeploymentElement> disappearBetweenCheckpoints;
	Set<DeploymentElement> appearAccumulator;
	Set<DeploymentElement> updateAccumulator;
	Set<DeploymentElement> disappearAccumulator;
	boolean deploymentBetweenCheckpointsChanged;
	boolean deploymentChanged;

	@Override
	public synchronized DeploymentChangeDelta createCheckpoint() {
		appearBetweenCheckpoints = appearAccumulator;
		updateBetweenCheckpoints = updateAccumulator;
		disappearBetweenCheckpoints = disappearAccumulator;
		appearAccumulator = Sets.newHashSet();
		updateAccumulator = Sets.newHashSet();
		disappearAccumulator = Sets.newHashSet();
		deploymentBetweenCheckpointsChanged = deploymentChanged;
		return new DeploymentChangeDelta(appearBetweenCheckpoints, updateBetweenCheckpoints, disappearBetweenCheckpoints, deploymentBetweenCheckpointsChanged);
	}

	@Override
	public DeploymentChangeDelta getDeltaSinceLastCheckpoint() {
		return new DeploymentChangeDelta(appearAccumulator, updateAccumulator, disappearAccumulator, deploymentChanged);
	}

	@Override
	public synchronized void startMonitoring(Deployment deployment,
			IncQueryEngine engine) throws IncQueryException {

		this.appearBetweenCheckpoints = Sets.newHashSet();
		this.updateBetweenCheckpoints = Sets.newHashSet();
		this.disappearBetweenCheckpoints = Sets.newHashSet();
		this.appearAccumulator = Sets.newHashSet();
		this.updateAccumulator = Sets.newHashSet();
		this.disappearAccumulator = Sets.newHashSet();
		deploymentBetweenCheckpointsChanged = false;
		deploymentChanged = false;

		UpdateCompleteBasedSchedulerFactory schedulerFactory = Schedulers.getIQEngineSchedulerFactory(engine);
		ExecutionSchema executionSchema = ExecutionSchemas.createIncQueryExecutionSchema(engine, schedulerFactory);

		Set<Job<?>> allJobs = Sets.newHashSet();

		Set<Job<IPatternMatch>> deploymentJobs = createDeploymentJobs();
		allJobs.addAll(deploymentJobs);

		IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> deploymentHostChangeQuerySpec = (IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) DeploymentHostsChangeQuerySpecification.instance();
		IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> deploymentHostIpChangeQuerySpec = (IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) DeploymentHostIpChangeQuerySpecification.instance();
		
		registerJobsForPattern(executionSchema, deploymentJobs, deploymentHostChangeQuerySpec);
		registerJobsForPattern(executionSchema, deploymentJobs, deploymentHostIpChangeQuerySpec);
		
		Set<Job<IPatternMatch>> deploymentElementJobs = createDeploymentElementJobs();
		allJobs.addAll(deploymentElementJobs);

		List<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>> querySpecifications = getDeploymentElementChangeQuerySpecifications();
		
		for (IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> querySpec : querySpecifications) {
			registerJobsForPattern(executionSchema, deploymentElementJobs,querySpec);
		}

		executionSchema.startUnscheduledExecution();

		// Enable the jobs to listen to changes
		for (Job<?> job : allJobs) {
			EnableJob<?> enableJob = (EnableJob<?>) job;
			enableJob.setEnabled(true);
		}

	}

	private List<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>> getDeploymentElementChangeQuerySpecifications()
			throws IncQueryException {
		List<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>> querySpecifications = Lists.newArrayList();
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) HostApplicationsChangeQuerySpecification.instance());
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) HostIpChangeQuerySpecification.instance());
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) ApplicationIdChangeQuerySpecification.instance());
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) ApplicationBehaviorChangeQuerySpecification.instance());
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) BehaviorChangeQuerySpecification.instance());
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) TransitionChangeQuerySpecification.instance());
		querySpecifications.add((IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>) TriggerChangeQuerySpecification.instance());
		return querySpecifications;
	}

	private void registerJobsForPattern(
			ExecutionSchema executionSchema,
			Set<Job<IPatternMatch>> deploymentElementJobs,
			IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>> changeQuerySpecification) {
		RuleSpecification<IPatternMatch> applicationRules = Rules
				.newMatcherRuleSpecification(
						changeQuerySpecification,
						Lifecycles.getDefault(true, true), 
						deploymentElementJobs);
		executionSchema.addRule(applicationRules);
	}

	private Set<Job<IPatternMatch>> createDeploymentJobs() {

		Set<Job<IPatternMatch>> jobs = Sets.newHashSet();
		
		Job<IPatternMatch> appear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.APPEARED,
				new IMatchProcessor<IPatternMatch>() {

					@Override
					public void process(IPatternMatch match) {
						deploymentChanged = true;
					}

				});
		Job<IPatternMatch> disappear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.DISAPPEARED,
				new IMatchProcessor<IPatternMatch>() {

					@Override
					public void process(IPatternMatch match) {
						deploymentChanged = true;
					}

				});
		Job<IPatternMatch> update = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.UPDATED,
				new IMatchProcessor<IPatternMatch>() {

					@Override
					public void process(IPatternMatch match) {
						deploymentChanged = true;
					}

				});

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
		
		return jobs;
	}

	
	private Set<Job<IPatternMatch>> createDeploymentElementJobs() {

		Set<Job<IPatternMatch>> jobs = Sets.newHashSet();
		
		Job<IPatternMatch> appear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.APPEARED,
				new IMatchProcessor<IPatternMatch>() {

					@Override
					public void process(IPatternMatch match) {
						DeploymentElement deploymentElement = (DeploymentElement) match.get(0);
						if(disappearAccumulator.contains(deploymentElement)){
							disappearAccumulator.remove(deploymentElement);
						}
						appearAccumulator.add(deploymentElement);
					}

				});
		Job<IPatternMatch> disappear = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.DISAPPEARED,
				new IMatchProcessor<IPatternMatch>() {

					@Override
					public void process(IPatternMatch match) {
						DeploymentElement deploymentElement = (DeploymentElement) match.get(0);
						if(appearAccumulator.contains(deploymentElement)){
							appearAccumulator.remove(deploymentElement);
						} else if(updateAccumulator.contains(deploymentElement)){
							updateAccumulator.remove(deploymentElement);
						} 
						disappearAccumulator.add(deploymentElement);
					}

				});
		Job<IPatternMatch> update = Jobs.newStatelessJob(
				IncQueryActivationStateEnum.UPDATED,
				new IMatchProcessor<IPatternMatch>() {

					@Override
					public void process(IPatternMatch match) {
						DeploymentElement deploymentElement = (DeploymentElement) match.get(0);
						if(appearAccumulator.contains(deploymentElement)){
							appearAccumulator.remove(deploymentElement);
						}
						updateAccumulator.add(deploymentElement);
					}

				});

		jobs.add(Jobs.newEnableJob(appear));
		jobs.add(Jobs.newEnableJob(disappear));
		jobs.add(Jobs.newEnableJob(update));
		
		return jobs;
	}

}
