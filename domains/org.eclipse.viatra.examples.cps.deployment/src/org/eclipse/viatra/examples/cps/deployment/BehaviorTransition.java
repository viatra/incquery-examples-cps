/**
 */
package org.eclipse.viatra.examples.cps.deployment;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Behavior Transition</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link org.eclipse.viatra.examples.cps.deployment.BehaviorTransition#getTo <em>To</em>}</li>
 *   <li>{@link org.eclipse.viatra.examples.cps.deployment.BehaviorTransition#getTrigger <em>Trigger</em>}</li>
 * </ul>
 *
 * @see org.eclipse.viatra.examples.cps.deployment.DeploymentPackage#getBehaviorTransition()
 * @model
 * @generated
 */
public interface BehaviorTransition extends DeploymentElement {
	/**
	 * Returns the value of the '<em><b>To</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>To</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>To</em>' reference.
	 * @see #setTo(BehaviorState)
	 * @see org.eclipse.viatra.examples.cps.deployment.DeploymentPackage#getBehaviorTransition_To()
	 * @model
	 * @generated
	 */
	BehaviorState getTo();

	/**
	 * Sets the value of the '{@link org.eclipse.viatra.examples.cps.deployment.BehaviorTransition#getTo <em>To</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>To</em>' reference.
	 * @see #getTo()
	 * @generated
	 */
	void setTo(BehaviorState value);

	/**
	 * Returns the value of the '<em><b>Trigger</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.viatra.examples.cps.deployment.BehaviorTransition}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Trigger</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Trigger</em>' reference list.
	 * @see org.eclipse.viatra.examples.cps.deployment.DeploymentPackage#getBehaviorTransition_Trigger()
	 * @model
	 * @generated
	 */
	EList<BehaviorTransition> getTrigger();

} // BehaviorTransition
