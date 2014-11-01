/**
 */
package org.eclipse.incquery.examples.cps.model;

import org.eclipse.emf.common.util.EList;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Application Instance</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getState <em>State</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getDbUser <em>Db User</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getDbPassword <em>Db Password</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getAllocatedTo <em>Allocated To</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getDependOn <em>Depend On</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getType <em>Type</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance()
 * @model
 * @generated
 */
public interface ApplicationInstance extends Identifiable {
	/**
	 * Returns the value of the '<em><b>State</b></em>' attribute.
	 * The literals are from the enumeration {@link org.eclipse.incquery.examples.cps.model.AppState}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>State</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>State</em>' attribute.
	 * @see org.eclipse.incquery.examples.cps.model.AppState
	 * @see #setState(AppState)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance_State()
	 * @model
	 * @generated
	 */
	AppState getState();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getState <em>State</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>State</em>' attribute.
	 * @see org.eclipse.incquery.examples.cps.model.AppState
	 * @see #getState()
	 * @generated
	 */
	void setState(AppState value);

	/**
	 * Returns the value of the '<em><b>Db User</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Db User</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Db User</em>' attribute.
	 * @see #setDbUser(String)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance_DbUser()
	 * @model
	 * @generated
	 */
	String getDbUser();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getDbUser <em>Db User</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Db User</em>' attribute.
	 * @see #getDbUser()
	 * @generated
	 */
	void setDbUser(String value);

	/**
	 * Returns the value of the '<em><b>Db Password</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Db Password</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Db Password</em>' attribute.
	 * @see #setDbPassword(String)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance_DbPassword()
	 * @model
	 * @generated
	 */
	String getDbPassword();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getDbPassword <em>Db Password</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Db Password</em>' attribute.
	 * @see #getDbPassword()
	 * @generated
	 */
	void setDbPassword(String value);

	/**
	 * Returns the value of the '<em><b>Allocated To</b></em>' reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.HostInstance#getApplications <em>Applications</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Allocated To</em>' reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Allocated To</em>' reference.
	 * @see #setAllocatedTo(HostInstance)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance_AllocatedTo()
	 * @see org.eclipse.incquery.examples.cps.model.HostInstance#getApplications
	 * @model opposite="applications"
	 * @generated
	 */
	HostInstance getAllocatedTo();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getAllocatedTo <em>Allocated To</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Allocated To</em>' reference.
	 * @see #getAllocatedTo()
	 * @generated
	 */
	void setAllocatedTo(HostInstance value);

	/**
	 * Returns the value of the '<em><b>Depend On</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.ApplicationInstance}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Depend On</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Depend On</em>' reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance_DependOn()
	 * @model
	 * @generated
	 */
	EList<ApplicationInstance> getDependOn();

	/**
	 * Returns the value of the '<em><b>Type</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getInstances <em>Instances</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Type</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Type</em>' container reference.
	 * @see #setType(ApplicationType)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationInstance_Type()
	 * @see org.eclipse.incquery.examples.cps.model.ApplicationType#getInstances
	 * @model opposite="instances" required="true" transient="false"
	 * @generated
	 */
	ApplicationType getType();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getType <em>Type</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Type</em>' container reference.
	 * @see #getType()
	 * @generated
	 */
	void setType(ApplicationType value);

} // ApplicationInstance
