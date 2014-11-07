package org.eclipse.incquery.examples.cps.xform.m2m;

import com.google.common.base.Objects;
import com.google.common.base.Preconditions;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class CPS2DeploymentTransformation {
  private Logger logger = Logger.getLogger(CPS2DeploymentTransformation.class);
  
  public CPS2DeploymentTransformation() {
    this.logger.setLevel(Level.INFO);
  }
  
  public void execute(final CPSToDeployment mapping) {
    CyberPhysicalSystem _cps = mapping.getCps();
    boolean _notEquals = (!Objects.equal(_cps, null));
    Preconditions.checkState(_notEquals, "CPS not defined in mapping!");
    Deployment _deployment = mapping.getDeployment();
    boolean _notEquals_1 = (!Objects.equal(_deployment, null));
    Preconditions.checkState(_notEquals_1, "Deployment not defined in mapping!");
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Executing transformation on:");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("Cyber-physical system: ");
    CyberPhysicalSystem _cps_1 = mapping.getCps();
    String _id = _cps_1.getId();
    _builder.append(_id, "\t");
    this.logger.info(_builder);
  }
}
