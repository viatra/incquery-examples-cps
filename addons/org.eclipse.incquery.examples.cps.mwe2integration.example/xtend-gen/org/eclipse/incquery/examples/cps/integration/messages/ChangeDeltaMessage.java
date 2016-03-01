package org.eclipse.incquery.examples.cps.integration.messages;

import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.viatra.integration.mwe2.IMessage;

@SuppressWarnings("all")
public class ChangeDeltaMessage implements IMessage<DeploymentChangeDelta> {
  private DeploymentChangeDelta parameter;
  
  public ChangeDeltaMessage(final DeploymentChangeDelta parameter) {
    super();
    this.parameter = parameter;
  }
  
  @Override
  public DeploymentChangeDelta getParameter() {
    return this.parameter;
  }
  
  @Override
  public void setParameter(final DeploymentChangeDelta parameter) {
    this.parameter = parameter;
  }
}
