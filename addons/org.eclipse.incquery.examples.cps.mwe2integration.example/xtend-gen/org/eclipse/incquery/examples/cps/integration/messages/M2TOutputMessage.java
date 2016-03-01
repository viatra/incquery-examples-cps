package org.eclipse.incquery.examples.cps.integration.messages;

import java.util.List;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.viatra.integration.mwe2.IMessage;

@SuppressWarnings("all")
public class M2TOutputMessage implements IMessage<List<M2TOutputRecord>> {
  private List<M2TOutputRecord> parameter;
  
  public M2TOutputMessage(final List<M2TOutputRecord> parameter) {
    super();
    this.parameter = parameter;
  }
  
  @Override
  public List<M2TOutputRecord> getParameter() {
    return this.parameter;
  }
  
  @Override
  public void setParameter(final List<M2TOutputRecord> parameter) {
    this.parameter = parameter;
  }
}
