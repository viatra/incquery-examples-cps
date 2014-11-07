package org.eclipse.incquery.examples.cps.xform.m2m.tests;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemFactory;
import org.eclipse.incquery.examples.cps.deployment.Deployment;
import org.eclipse.incquery.examples.cps.deployment.DeploymentFactory;
import org.eclipse.incquery.examples.cps.traceability.CPSToDeployment;
import org.eclipse.incquery.examples.cps.traceability.TraceabilityFactory;
import org.eclipse.incquery.examples.cps.xform.m2m.CPS2DeploymentTransformation;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;

@SuppressWarnings("all")
public class CPS2DepTest {
  private final Logger logger = Logger.getLogger(CPS2DepTest.class);
  
  private final CyberPhysicalSystemFactory cpsFactory = CyberPhysicalSystemFactory.eINSTANCE;
  
  private final DeploymentFactory depFactory = DeploymentFactory.eINSTANCE;
  
  private final TraceabilityFactory traceFactory = TraceabilityFactory.eINSTANCE;
  
  @Test
  public void emptyModel() {
    this.logger.setLevel(Level.INFO);
    this.logger.info("START TEST: empty model");
    final ResourceSetImpl rs = new ResourceSetImpl();
    URI _createURI = URI.createURI("dummyCPSUri");
    final Resource cpsRes = rs.createResource(_createURI);
    URI _createURI_1 = URI.createURI("dummyDeploymentUri");
    final Resource depRes = rs.createResource(_createURI_1);
    URI _createURI_2 = URI.createURI("dummyTraceabilityUri");
    final Resource trcRes = rs.createResource(_createURI_2);
    CyberPhysicalSystem _createCyberPhysicalSystem = this.cpsFactory.createCyberPhysicalSystem();
    final Procedure1<CyberPhysicalSystem> _function = new Procedure1<CyberPhysicalSystem>() {
      public void apply(final CyberPhysicalSystem it) {
        it.setId("Empty CPS model");
      }
    };
    final CyberPhysicalSystem cps = ObjectExtensions.<CyberPhysicalSystem>operator_doubleArrow(_createCyberPhysicalSystem, _function);
    EList<EObject> _contents = cpsRes.getContents();
    _contents.add(cps);
    final Deployment dep = this.depFactory.createDeployment();
    EList<EObject> _contents_1 = depRes.getContents();
    _contents_1.add(dep);
    CPSToDeployment _createCPSToDeployment = this.traceFactory.createCPSToDeployment();
    final Procedure1<CPSToDeployment> _function_1 = new Procedure1<CPSToDeployment>() {
      public void apply(final CPSToDeployment it) {
        it.setCps(cps);
        it.setDeployment(dep);
      }
    };
    final CPSToDeployment cps2dep = ObjectExtensions.<CPSToDeployment>operator_doubleArrow(_createCPSToDeployment, _function_1);
    EList<EObject> _contents_2 = trcRes.getContents();
    _contents_2.add(cps2dep);
    final CPS2DeploymentTransformation xform = new CPS2DeploymentTransformation();
    xform.execute(cps2dep);
    this.logger.info("END TEST: empty model");
  }
}
