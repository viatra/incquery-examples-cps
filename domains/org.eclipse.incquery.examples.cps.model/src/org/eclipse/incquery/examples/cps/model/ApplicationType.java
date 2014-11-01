/**
 */
package org.eclipse.incquery.examples.cps.model;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Application Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getExeFileLocation <em>Exe File Location</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getExeType <em>Exe Type</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getZipFileUrl <em>Zip File Url</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getRequirements <em>Requirements</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getCps <em>Cps</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getInstances <em>Instances</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getBehavior <em>Behavior</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType()
 * @model
 * @generated
 */
public interface ApplicationType extends Identifiable {
	/**
	 * Returns the value of the '<em><b>Exe File Location</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Exe File Location</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Exe File Location</em>' attribute.
	 * @see #setExeFileLocation(String)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_ExeFileLocation()
	 * @model
	 * @generated
	 */
	String getExeFileLocation();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getExeFileLocation <em>Exe File Location</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Exe File Location</em>' attribute.
	 * @see #getExeFileLocation()
	 * @generated
	 */
	void setExeFileLocation(String value);

	/**
	 * Returns the value of the '<em><b>Exe Type</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Exe Type</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Exe Type</em>' attribute.
	 * @see #setExeType(String)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_ExeType()
	 * @model
	 * @generated
	 */
	String getExeType();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getExeType <em>Exe Type</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Exe Type</em>' attribute.
	 * @see #getExeType()
	 * @generated
	 */
	void setExeType(String value);

	/**
	 * Returns the value of the '<em><b>Zip File Url</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Zip File Url</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Zip File Url</em>' attribute.
	 * @see #setZipFileUrl(String)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_ZipFileUrl()
	 * @model
	 * @generated
	 */
	String getZipFileUrl();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getZipFileUrl <em>Zip File Url</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Zip File Url</em>' attribute.
	 * @see #getZipFileUrl()
	 * @generated
	 */
	void setZipFileUrl(String value);

	/**
	 * Returns the value of the '<em><b>Requirements</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.ResourceRequirement}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Requirements</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Requirements</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_Requirements()
	 * @model containment="true"
	 * @generated
	 */
	EList<ResourceRequirement> getRequirements();

	/**
	 * Returns the value of the '<em><b>Cps</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getAppTypes <em>App Types</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Cps</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Cps</em>' container reference.
	 * @see #setCps(CyberPhysicalSystem)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_Cps()
	 * @see org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getAppTypes
	 * @model opposite="appTypes" required="true" transient="false"
	 * @generated
	 */
	CyberPhysicalSystem getCps();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getCps <em>Cps</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Cps</em>' container reference.
	 * @see #getCps()
	 * @generated
	 */
	void setCps(CyberPhysicalSystem value);

	/**
	 * Returns the value of the '<em><b>Instances</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.ApplicationInstance}.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.ApplicationInstance#getType <em>Type</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Instances</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Instances</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_Instances()
	 * @see org.eclipse.incquery.examples.cps.model.ApplicationInstance#getType
	 * @model opposite="type" containment="true"
	 * @generated
	 */
	EList<ApplicationInstance> getInstances();

	/**
	 * Returns the value of the '<em><b>Behavior</b></em>' containment reference.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Behavior</em>' containment reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Behavior</em>' containment reference.
	 * @see #setBehavior(StateMachine)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getApplicationType_Behavior()
	 * @model containment="true"
	 * @generated
	 */
	StateMachine getBehavior();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.ApplicationType#getBehavior <em>Behavior</em>}' containment reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Behavior</em>' containment reference.
	 * @see #getBehavior()
	 * @generated
	 */
	void setBehavior(StateMachine value);

} // ApplicationType
