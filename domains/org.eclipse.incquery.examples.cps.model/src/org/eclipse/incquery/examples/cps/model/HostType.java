/**
 */
package org.eclipse.incquery.examples.cps.model;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Host Type</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.HostType#getDefaultCpu <em>Default Cpu</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.HostType#getDefaultRam <em>Default Ram</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.HostType#getDefaultHdd <em>Default Hdd</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.HostType#getCps <em>Cps</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.HostType#getInstances <em>Instances</em>}</li>
 * </ul>
 * </p>
 *
 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getHostType()
 * @model
 * @generated
 */
public interface HostType extends Identifiable {
	/**
	 * Returns the value of the '<em><b>Default Cpu</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Default Cpu</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Cpu</em>' attribute.
	 * @see #setDefaultCpu(int)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getHostType_DefaultCpu()
	 * @model
	 * @generated
	 */
	int getDefaultCpu();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.HostType#getDefaultCpu <em>Default Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Cpu</em>' attribute.
	 * @see #getDefaultCpu()
	 * @generated
	 */
	void setDefaultCpu(int value);

	/**
	 * Returns the value of the '<em><b>Default Ram</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Default Ram</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Ram</em>' attribute.
	 * @see #setDefaultRam(int)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getHostType_DefaultRam()
	 * @model
	 * @generated
	 */
	int getDefaultRam();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.HostType#getDefaultRam <em>Default Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Ram</em>' attribute.
	 * @see #getDefaultRam()
	 * @generated
	 */
	void setDefaultRam(int value);

	/**
	 * Returns the value of the '<em><b>Default Hdd</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Default Hdd</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Default Hdd</em>' attribute.
	 * @see #setDefaultHdd(int)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getHostType_DefaultHdd()
	 * @model
	 * @generated
	 */
	int getDefaultHdd();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.HostType#getDefaultHdd <em>Default Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Default Hdd</em>' attribute.
	 * @see #getDefaultHdd()
	 * @generated
	 */
	void setDefaultHdd(int value);

	/**
	 * Returns the value of the '<em><b>Cps</b></em>' container reference.
	 * It is bidirectional and its opposite is '{@link org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getHostTypes <em>Host Types</em>}'.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Cps</em>' container reference isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Cps</em>' container reference.
	 * @see #setCps(CyberPhysicalSystem)
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getHostType_Cps()
	 * @see org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem#getHostTypes
	 * @model opposite="hostTypes" required="true" transient="false"
	 * @generated
	 */
	CyberPhysicalSystem getCps();

	/**
	 * Sets the value of the '{@link org.eclipse.incquery.examples.cps.model.HostType#getCps <em>Cps</em>}' container reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Cps</em>' container reference.
	 * @see #getCps()
	 * @generated
	 */
	void setCps(CyberPhysicalSystem value);

	/**
	 * Returns the value of the '<em><b>Instances</b></em>' containment reference list.
	 * The list contents are of type {@link org.eclipse.incquery.examples.cps.model.HostInstance}.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Instances</em>' containment reference list isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Instances</em>' containment reference list.
	 * @see org.eclipse.incquery.examples.cps.model.ModelPackage#getHostType_Instances()
	 * @model containment="true"
	 * @generated
	 */
	EList<HostInstance> getInstances();

} // HostType
