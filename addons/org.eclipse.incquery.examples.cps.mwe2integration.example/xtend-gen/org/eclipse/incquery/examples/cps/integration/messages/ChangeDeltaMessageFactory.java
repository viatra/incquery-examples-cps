package org.eclipse.incquery.examples.cps.integration.messages;

import org.eclipse.incquery.examples.cps.integration.messages.ChangeDeltaMessage;
import org.eclipse.incquery.examples.cps.xform.m2t.monitor.DeploymentChangeDelta;
import org.eclipse.viatra.integration.mwe2.IMessageFactory;
import org.eclipse.viatra.integration.mwe2.mwe2impl.exceptions.InvalidParameterTypeException;

@SuppressWarnings("all")
public class ChangeDeltaMessageFactory implements IMessageFactory<DeploymentChangeDelta, ChangeDeltaMessage> {
  @Override
  public boolean isValidParameter(final Object parameter) {
    if ((parameter instanceof DeploymentChangeDelta)) {
      return true;
    }
    return false;
  }
  
  @Override
  public ChangeDeltaMessage createMessage(final Object parameter) throws InvalidParameterTypeException {
    boolean _isValidParameter = this.isValidParameter(parameter);
    if (_isValidParameter) {
      return new ChangeDeltaMessage(((DeploymentChangeDelta) parameter));
    }
    return null;
  }
}
