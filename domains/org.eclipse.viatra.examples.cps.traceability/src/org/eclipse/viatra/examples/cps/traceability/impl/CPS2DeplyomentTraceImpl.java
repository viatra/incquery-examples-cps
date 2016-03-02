/**
 */
package org.eclipse.viatra.examples.cps.traceability.impl;

import java.util.Collection;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;
import org.eclipse.emf.ecore.util.EObjectResolvingEList;
import org.eclipse.viatra.examples.cps.cyberPhysicalSystem.Identifiable;
import org.eclipse.viatra.examples.cps.deployment.DeploymentElement;
import org.eclipse.viatra.examples.cps.traceability.CPS2DeplyomentTrace;
import org.eclipse.viatra.examples.cps.traceability.TraceabilityPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>CPS2 Deplyoment Trace</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.viatra.examples.cps.traceability.impl.CPS2DeplyomentTraceImpl#getCpsElements <em>Cps Elements</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.traceability.impl.CPS2DeplyomentTraceImpl#getDeploymentElements <em>Deployment Elements</em>}</li>
 * </ul>
 *
 * @generated
 */
public class CPS2DeplyomentTraceImpl extends MinimalEObjectImpl.Container implements CPS2DeplyomentTrace {
	/**
	 * The cached value of the '{@link #getCpsElements() <em>Cps Elements</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCpsElements()
	 * @generated
	 * @ordered
	 */
	protected EList<Identifiable> cpsElements;

	/**
	 * The cached value of the '{@link #getDeploymentElements() <em>Deployment Elements</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDeploymentElements()
	 * @generated
	 * @ordered
	 */
	protected EList<DeploymentElement> deploymentElements;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected CPS2DeplyomentTraceImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return TraceabilityPackage.Literals.CPS2_DEPLYOMENT_TRACE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Identifiable> getCpsElements() {
		if (cpsElements == null) {
			cpsElements = new EObjectResolvingEList<Identifiable>(Identifiable.class, this, TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__CPS_ELEMENTS);
		}
		return cpsElements;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<DeploymentElement> getDeploymentElements() {
		if (deploymentElements == null) {
			deploymentElements = new EObjectResolvingEList<DeploymentElement>(DeploymentElement.class, this, TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__DEPLOYMENT_ELEMENTS);
		}
		return deploymentElements;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__CPS_ELEMENTS:
				return getCpsElements();
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__DEPLOYMENT_ELEMENTS:
				return getDeploymentElements();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__CPS_ELEMENTS:
				getCpsElements().clear();
				getCpsElements().addAll((Collection<? extends Identifiable>)newValue);
				return;
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__DEPLOYMENT_ELEMENTS:
				getDeploymentElements().clear();
				getDeploymentElements().addAll((Collection<? extends DeploymentElement>)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__CPS_ELEMENTS:
				getCpsElements().clear();
				return;
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__DEPLOYMENT_ELEMENTS:
				getDeploymentElements().clear();
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__CPS_ELEMENTS:
				return cpsElements != null && !cpsElements.isEmpty();
			case TraceabilityPackage.CPS2_DEPLYOMENT_TRACE__DEPLOYMENT_ELEMENTS:
				return deploymentElements != null && !deploymentElements.isEmpty();
		}
		return super.eIsSet(featureID);
	}

} //CPS2DeplyomentTraceImpl
