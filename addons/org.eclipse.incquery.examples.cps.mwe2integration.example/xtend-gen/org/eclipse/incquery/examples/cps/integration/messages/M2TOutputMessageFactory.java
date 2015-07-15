package org.eclipse.incquery.examples.cps.integration.messages;

import com.google.common.base.Objects;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.incquery.examples.cps.integration.messages.M2TOutputMessage;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;
import org.eclipse.viatra.emf.mwe2integration.IMessageFactory;
import org.eclipse.viatra.emf.mwe2integration.mwe2impl.exceptions.InvalidParameterTypeException;

@SuppressWarnings("all")
public class M2TOutputMessageFactory implements IMessageFactory<List<M2TOutputRecord>, M2TOutputMessage> {
  @Override
  public boolean isValidParameter(final Object parameter) {
    List<M2TOutputRecord> list = ((List<M2TOutputRecord>) parameter);
    boolean _notEquals = (!Objects.equal(list, null));
    if (_notEquals) {
      return true;
    } else {
      return false;
    }
  }
  
  @Override
  public M2TOutputMessage createMessage(final Object parameter) throws InvalidParameterTypeException {
    boolean _isValidParameter = this.isValidParameter(parameter);
    if (_isValidParameter) {
      return new M2TOutputMessage(((List<M2TOutputRecord>) parameter));
    }
    ArrayList<M2TOutputRecord> _arrayList = new ArrayList<M2TOutputRecord>();
    return new M2TOutputMessage(_arrayList);
  }
}
