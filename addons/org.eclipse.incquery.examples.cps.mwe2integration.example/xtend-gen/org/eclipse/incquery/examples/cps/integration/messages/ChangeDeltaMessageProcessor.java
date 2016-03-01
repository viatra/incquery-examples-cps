package org.eclipse.incquery.examples.cps.integration.messages;

import java.security.InvalidParameterException;
import org.eclipse.incquery.examples.cps.integration.M2TDistributedTransformationStep;
import org.eclipse.incquery.examples.cps.integration.messages.ChangeDeltaMessage;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.viatra.integration.mwe2.IMessage;
import org.eclipse.viatra.integration.mwe2.IMessageProcessor;
import org.eclipse.viatra.integration.mwe2.ITransformationStep;

@SuppressWarnings("all")
public class ChangeDeltaMessageProcessor implements IMessageProcessor<DeploymentChangeDelta, ChangeDeltaMessage> {
  protected ITransformationStep parent;
  
  @Override
  public ITransformationStep getParent() {
    return this.parent;
  }
  
  @Override
  public void setParent(final ITransformationStep parent) {
    this.parent = parent;
  }
  
  @Override
  public void processMessage(final IMessage<?> message) throws InvalidParameterException {
    if ((message instanceof ChangeDeltaMessage)) {
      ChangeDeltaMessage event = ((ChangeDeltaMessage) message);
      if ((this.parent instanceof M2TDistributedTransformationStep)) {
        M2TDistributedTransformationStep m2tparent = ((M2TDistributedTransformationStep) this.parent);
        DeploymentChangeDelta _parameter = event.getParameter();
        m2tparent.delta = _parameter;
      }
    }
  }
}
