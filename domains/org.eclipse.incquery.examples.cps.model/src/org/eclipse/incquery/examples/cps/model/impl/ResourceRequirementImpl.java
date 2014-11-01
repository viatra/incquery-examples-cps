/**
 */
package org.eclipse.incquery.examples.cps.model.impl;

import org.eclipse.incquery.examples.cps.model.HostType;
import org.eclipse.incquery.examples.cps.model.ModelPackage;
import org.eclipse.incquery.examples.cps.model.ResourceRequirement;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Resource Requirement</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.ResourceRequirementImpl#getRequiredCpu <em>Required Cpu</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.ResourceRequirementImpl#getRequiredRam <em>Required Ram</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.ResourceRequirementImpl#getRequiredHdd <em>Required Hdd</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.ResourceRequirementImpl#getType <em>Type</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class ResourceRequirementImpl extends MinimalEObjectImpl.Container implements ResourceRequirement {
	/**
	 * The default value of the '{@link #getRequiredCpu() <em>Required Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequiredCpu()
	 * @generated
	 * @ordered
	 */
	protected static final int REQUIRED_CPU_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getRequiredCpu() <em>Required Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequiredCpu()
	 * @generated
	 * @ordered
	 */
	protected int requiredCpu = REQUIRED_CPU_EDEFAULT;

	/**
	 * The default value of the '{@link #getRequiredRam() <em>Required Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequiredRam()
	 * @generated
	 * @ordered
	 */
	protected static final int REQUIRED_RAM_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getRequiredRam() <em>Required Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequiredRam()
	 * @generated
	 * @ordered
	 */
	protected int requiredRam = REQUIRED_RAM_EDEFAULT;

	/**
	 * The default value of the '{@link #getRequiredHdd() <em>Required Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequiredHdd()
	 * @generated
	 * @ordered
	 */
	protected static final int REQUIRED_HDD_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getRequiredHdd() <em>Required Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequiredHdd()
	 * @generated
	 * @ordered
	 */
	protected int requiredHdd = REQUIRED_HDD_EDEFAULT;

	/**
	 * The cached value of the '{@link #getType() <em>Type</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getType()
	 * @generated
	 * @ordered
	 */
	protected HostType type;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ResourceRequirementImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return ModelPackage.Literals.RESOURCE_REQUIREMENT;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getRequiredCpu() {
		return requiredCpu;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRequiredCpu(int newRequiredCpu) {
		int oldRequiredCpu = requiredCpu;
		requiredCpu = newRequiredCpu;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_CPU, oldRequiredCpu, requiredCpu));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getRequiredRam() {
		return requiredRam;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRequiredRam(int newRequiredRam) {
		int oldRequiredRam = requiredRam;
		requiredRam = newRequiredRam;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_RAM, oldRequiredRam, requiredRam));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getRequiredHdd() {
		return requiredHdd;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setRequiredHdd(int newRequiredHdd) {
		int oldRequiredHdd = requiredHdd;
		requiredHdd = newRequiredHdd;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_HDD, oldRequiredHdd, requiredHdd));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public HostType getType() {
		if (type != null && type.eIsProxy()) {
			InternalEObject oldType = (InternalEObject)type;
			type = (HostType)eResolveProxy(oldType);
			if (type != oldType) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, ModelPackage.RESOURCE_REQUIREMENT__TYPE, oldType, type));
			}
		}
		return type;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public HostType basicGetType() {
		return type;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setType(HostType newType) {
		HostType oldType = type;
		type = newType;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.RESOURCE_REQUIREMENT__TYPE, oldType, type));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_CPU:
				return getRequiredCpu();
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_RAM:
				return getRequiredRam();
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_HDD:
				return getRequiredHdd();
			case ModelPackage.RESOURCE_REQUIREMENT__TYPE:
				if (resolve) return getType();
				return basicGetType();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_CPU:
				setRequiredCpu((Integer)newValue);
				return;
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_RAM:
				setRequiredRam((Integer)newValue);
				return;
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_HDD:
				setRequiredHdd((Integer)newValue);
				return;
			case ModelPackage.RESOURCE_REQUIREMENT__TYPE:
				setType((HostType)newValue);
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
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_CPU:
				setRequiredCpu(REQUIRED_CPU_EDEFAULT);
				return;
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_RAM:
				setRequiredRam(REQUIRED_RAM_EDEFAULT);
				return;
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_HDD:
				setRequiredHdd(REQUIRED_HDD_EDEFAULT);
				return;
			case ModelPackage.RESOURCE_REQUIREMENT__TYPE:
				setType((HostType)null);
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
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_CPU:
				return requiredCpu != REQUIRED_CPU_EDEFAULT;
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_RAM:
				return requiredRam != REQUIRED_RAM_EDEFAULT;
			case ModelPackage.RESOURCE_REQUIREMENT__REQUIRED_HDD:
				return requiredHdd != REQUIRED_HDD_EDEFAULT;
			case ModelPackage.RESOURCE_REQUIREMENT__TYPE:
				return type != null;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuffer result = new StringBuffer(super.toString());
		result.append(" (requiredCpu: ");
		result.append(requiredCpu);
		result.append(", requiredRam: ");
		result.append(requiredRam);
		result.append(", requiredHdd: ");
		result.append(requiredHdd);
		result.append(')');
		return result.toString();
	}

} //ResourceRequirementImpl
