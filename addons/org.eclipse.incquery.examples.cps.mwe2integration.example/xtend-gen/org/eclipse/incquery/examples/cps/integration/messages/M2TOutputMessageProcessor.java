package org.eclipse.incquery.examples.cps.integration.messages;

import java.security.InvalidParameterException;
import java.util.List;
import org.eclipse.incquery.examples.cps.integration.SerializerTransformationStep;
import org.eclipse.incquery.examples.cps.integration.messages.M2TOutputMessage;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.viatra.integration.mwe2.IMessage;
import org.eclipse.viatra.integration.mwe2.IMessageProcessor;
import org.eclipse.viatra.integration.mwe2.ITransformationStep;

@SuppressWarnings("all")
public class M2TOutputMessageProcessor implements IMessageProcessor<List<M2TOutputRecord>, M2TOutputMessage> {
  private ITransformationStep parent;
  
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
    if ((message instanceof M2TOutputMessage)) {
      M2TOutputMessage event = ((M2TOutputMessage) message);
      if ((this.parent instanceof SerializerTransformationStep)) {
        SerializerTransformationStep serializerparent = ((SerializerTransformationStep) this.parent);
        List<M2TOutputRecord> _parameter = event.getParameter();
        serializerparent.m2tOutput = _parameter;
      }
    }
  }
}
