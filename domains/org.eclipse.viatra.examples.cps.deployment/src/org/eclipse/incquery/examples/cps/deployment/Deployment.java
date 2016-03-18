/**
 */
package org.eclipse.incquery.examples.cps.deployment;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Deployment</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.deployment.Deployment#getHosts <em>Hosts</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.deployment.DeploymentPackage#getDeployment()
 * @model
 * @generated
 */
public interface Deployment extends EObject {
	/**
	 * Returns the value of the '<em><b>Hosts</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.deployment.DeploymentHost}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Hosts</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Hosts</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.deployment.DeploymentPackage#getDeployment_Hosts()
	 * @model containment="true"
	 * @generated
	 */
	EList<DeploymentHost> getHosts();

} // Deployment
