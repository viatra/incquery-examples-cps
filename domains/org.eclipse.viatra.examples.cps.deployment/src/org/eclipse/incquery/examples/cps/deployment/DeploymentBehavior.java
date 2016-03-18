/**
 */
package org.eclipse.incquery.examples.cps.deployment;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Behavior</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior#getStates <em>States</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior#getTransitions <em>Transitions</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior#getCurrent <em>Current</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.deployment.DeploymentPackage#getDeploymentBehavior()
 * @model
 * @generated
 */
public interface DeploymentBehavior extends DeploymentElement {
	/**
	 * Returns the value of the '<em><b>States</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.deployment.BehaviorState}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>States</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>States</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.deployment.DeploymentPackage#getDeploymentBehavior_States()
	 * @model containment="true"
	 * @generated
	 */
	EList<BehaviorState> getStates();

	/**
	 * Returns the value of the '<em><b>Transitions</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.deployment.BehaviorTransition}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Transitions</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Transitions</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.deployment.DeploymentPackage#getDeploymentBehavior_Transitions()
	 * @model containment="true"
	 * @generated
	 */
	EList<BehaviorTransition> getTransitions();

	/**
	 * Returns the value of the '<em><b>Current</b></em>' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * <!-- begin-model-doc -->
	 * The initial state of the state machine will be the first current behavior state.
	 * <!-- end-model-doc -->
	 * @return the value of the '<em>Current</em>' reference.
	 * @see #setCurrent(BehaviorState)
	 * @see org.eclipse.incquery.examples.cps.deployment.DeploymentPackage#getDeploymentBehavior_Current()
	 * @model
	 * @generated
	 */
	BehaviorState getCurrent();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior#getCurrent <em>Current</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Current</em>' reference.
	 * @see #getCurrent()
	 * @generated
	 */
	void setCurrent(BehaviorState value);

} // DeploymentBehavior
