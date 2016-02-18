package org.eclipse.incquery.examples.cps.integration.messages;

import java.security.InvalidParameterException;
import org.eclipse.incquery.examples.cps.integration.M2TDistributedTransformationStep;
import org.eclipse.incquery.examples.cps.integration.messages.ChangeDeltaMessage;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;

@SuppressWarnings("all")
public class ChangeDeltaMessageProcessor /* implements IMessageProcessor<DeploymentChangeDelta, ChangeDeltaMessage>  */{
  protected /* ITransformationStep */Object parent;
  
  @Override
  public /* ITransformationStep */Object getParent() {
    return this.parent;
  }
  
  @Override
  public void setParent(final /* ITransformationStep */Object parent) {
    this.parent = parent;
  }
  
  @Override
  public void processMessage(final /* IMessage<?> */Object message) throws InvalidParameterException {
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
