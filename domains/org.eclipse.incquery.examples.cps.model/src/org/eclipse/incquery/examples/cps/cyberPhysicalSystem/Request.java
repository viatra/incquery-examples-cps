/**
 */
package org.eclipse.incquery.examples.cps.cyberPhysicalSystem;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Request</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Request#getRequirements <em>Requirements</em>}</li>
 * </ul>
 *
 * @see org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getRequest()
 * @model
 * @generated
 */
public interface Request extends Identifiable {
	/**
     * Returns the value of the '<em><b>Requirements</b></em>' containment reference list.
     * The list contents are of type {@link org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Requirement}.
     * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Requirement#getRequest <em>Request</em>}'.
     * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Requirements</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
     * @return the value of the '<em>Requirements</em>' containment reference list.
     * @see org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystemPackage#getRequest_Requirements()
     * @see org.eclipse.incquery.examples.cps.cyberPhysicalSystem.Requirement#getRequest
     * @model opposite="request" containment="true"
     * @generated
     */
	EList<Requirement> getRequirements();

} // Request
