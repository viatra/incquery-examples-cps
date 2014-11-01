/**
 */
package org.eclipse.incquery.examples.cps.traceability;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

import org.eclipse.incquery.examples.cps.deployment.DeploymentElement;

import org.eclipse.incquery.examples.cps.model.Identifiable;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>CPS2 Deplyoment Trace</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace#getCpsElements <em>Cps Elements</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.traceability.CPS2DeplyomentTrace#getDeploymentElements <em>Deployment Elements</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.traceability.TraceabilityPackage#getCPS2DeplyomentTrace()
 * @model
 * @generated
 */
public interface CPS2DeplyomentTrace extends EObject {
	/**
	 * Returns the value of the '<em><b>Cps Elements</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.Identifiable}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Cps Elements</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Cps Elements</em>' reference list.
	 * @see org.eclipse.incquery.examples.cps.traceability.TraceabilityPackage#getCPS2DeplyomentTrace_CpsElements()
	 * @model
	 * @generated
	 */
	EList<Identifiable> getCpsElements();

	/**
	 * Returns the value of the '<em><b>Deployment Elements</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.deployment.DeploymentElement}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Deployment Elements</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Deployment Elements</em>' reference list.
	 * @see org.eclipse.incquery.examples.cps.traceability.TraceabilityPackage#getCPS2DeplyomentTrace_DeploymentElements()
	 * @model
	 * @generated
	 */
	EList<DeploymentElement> getDeploymentElements();

} // CPS2DeplyomentTrace
