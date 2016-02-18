package org.eclipse.incquery.examples.cps.integration.messages;

import org.eclipse.incquery.examples.cps.integration.messages.ChangeDeltaMessage;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;

@SuppressWarnings("all")
public class ChangeDeltaMessageFactory /* implements IMessageFactory<DeploymentChangeDelta, ChangeDeltaMessage>  */{
  @Override
  public boolean isValidParameter(final Object parameter) {
    if ((parameter instanceof DeploymentChangeDelta)) {
      return true;
    }
    return false;
  }
  
  @Override
  public ChangeDeltaMessage createMessage(final Object parameter)/*  throws InvalidParameterTypeException */ {
    boolean _isValidParameter = this.isValidParameter(parameter);
    if (_isValidParameter) {
      return new ChangeDeltaMessage(((DeploymentChangeDelta) parameter));
    }
    return null;
  }
}
