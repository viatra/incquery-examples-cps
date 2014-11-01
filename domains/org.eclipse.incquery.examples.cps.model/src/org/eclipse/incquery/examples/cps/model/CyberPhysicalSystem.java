/**
 */
package org.eclipse.incquery.examples.cps.model;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Cyber Physical System</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getDbUrl <em>Db Url</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getAppTypes <em>App Types</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getRequests <em>Requests</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getHostTypes <em>Host Types</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getHostInstances <em>Host Instances</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getAppInstances <em>App Instances</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem()
 * @model
 * @generated
 */
public interface CyberPhysicalSystem extends Identifiable {
	/**
	 * Returns the value of the '<em><b>Db Url</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Db Url</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Db Url</em>' attribute.
	 * @see #setDbUrl(String)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem_DbUrl()
	 * @model
	 * @generated
	 */
	String getDbUrl();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getDbUrl <em>Db Url</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Db Url</em>' attribute.
	 * @see #getDbUrl()
	 * @generated
	 */
	void setDbUrl(String value);

	/**
	 * Returns the value of the '<em><b>App Types</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.ApplicationType}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getCps <em>Cps</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>App Types</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>App Types</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem_AppTypes()
	 * @see org.eclipse.incquery.examples.cps.model.ApplicationType#getCps
	 * @model opposite="cps" containment="true"
	 * @generated
	 */
	EList<ApplicationType> getAppTypes();

	/**
	 * Returns the value of the '<em><b>Requests</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.Request}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Requests</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Requests</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem_Requests()
	 * @model containment="true"
	 * @generated
	 */
	EList<Request> getRequests();

	/**
	 * Returns the value of the '<em><b>Host Types</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.HostType}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.HostType#getCps <em>Cps</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Host Types</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Host Types</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem_HostTypes()
	 * @see org.eclipse.incquery.examples.cps.model.HostType#getCps
	 * @model opposite="cps" containment="true"
	 * @generated
	 */
	EList<HostType> getHostTypes();

	/**
	 * Returns the value of the '<em><b>Host Instances</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.HostInstance}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Host Instances</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Host Instances</em>' reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem_HostInstances()
	 * @model transient="true" changeable="false" volatile="true" derived="true"
	 *        annotation="org.eclipse.incquery.querybasedfeature patternFQN='org.eclipse.incquery.examples.cps.model.derived.hostInstances'"
	 * @generated
	 */
	EList<HostInstance> getHostInstances();

	/**
	 * Returns the value of the '<em><b>App Instances</b></em>' reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.ApplicationInstance}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>App Instances</em>' reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>App Instances</em>' reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getCyberPhysicalSystem_AppInstances()
	 * @model transient="true" changeable="false" volatile="true" derived="true"
	 *        annotation="org.eclipse.incquery.querybasedfeature patternFQN='org.eclipse.incquery.examples.cps.model.derived.getAppInstances'"
	 * @generated
	 */
	EList<ApplicationInstance> getAppInstances();

} // CyberPhysicalSystem
