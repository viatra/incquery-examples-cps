package org.eclipse.incquery.examples.cps.xform.m2t.util.monitor;

import java.util.Map;

import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication;
import org.eclipse.incquery.examples.cps.deployment.DeploymentElement;
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost;
import org.eclipse.incquery.runtime.api.IMatchProcessor;
import org.eclipse.incquery.runtime.api.IPatternMatch;
import org.eclipse.incquery.runtime.evm.api.Activation;
import org.eclipse.incquery.runtime.evm.api.Context;
import org.eclipse.incquery.runtime.evm.specific.event.IncQueryActivationStateEnum;
import org.eclipse.incquery.runtime.evm.specific.job.StatelessJob;

import com.google.common.collect.Maps;

public class ChangeMonitorJob<Match extends IPatternMatch> extends StatelessJob<Match> {

	private static final String OUTDATED_ELEMENTS = "changedDeploymentElements";

	public ChangeMonitorJob(
			IncQueryActivationStateEnum incQueryActivationStateEnum,
			IMatchProcessor<Match> matchProcessor) {
		super(incQueryActivationStateEnum, matchProcessor);
	}

	@Override
	protected void execute(Activation<? extends Match> activation, Context context) {
		// For update jobs, store the old name
		if(getActivationState().equals(IncQueryActivationStateEnum.UPDATED)){
			@SuppressWarnings("unchecked")
			Map<DeploymentElement, String> map = (Map<DeploymentElement, String>) context.get(OUTDATED_ELEMENTS);
			if (map == null) {
				map = Maps.newHashMap();
				context.put(OUTDATED_ELEMENTS, map);
			}
			DeploymentElement changedElement = (DeploymentElement) activation.getAtom().get(0);
			store(changedElement, map);
		}
		
	}

	private void store(DeploymentElement changedElement, Map<DeploymentElement, String> map) {
		if(changedElement instanceof DeploymentHost){
			map.put(changedElement, ((DeploymentHost)changedElement).getIp());						
		}
		else if(changedElement instanceof DeploymentApplication){
			map.put(changedElement, ((DeploymentApplication)changedElement).getId());						
		} else {
			throw new IllegalStateException("Unexpected DeploymentElement subtype encountered: " + changedElement.getClass().toString());
		}
	}

	@Override
	protected void handleError(Activation<? extends Match> activation, Exception exception, Context context) {
		context.remove(OUTDATED_ELEMENTS);
		super.handleError(activation,exception,context);
	}

}
