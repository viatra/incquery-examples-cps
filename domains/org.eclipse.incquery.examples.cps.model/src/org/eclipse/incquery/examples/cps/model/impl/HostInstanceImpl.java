/**
 */
package org.eclipse.incquery.examples.cps.model.impl;

import org.eclipse.incquery.examples.cps.model.ApplicationInstance;
import org.eclipse.incquery.examples.cps.model.HostInstance;
import org.eclipse.incquery.examples.cps.model.ModelPackage;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EObjectResolvingEList;
import org.eclipse.emf.ecore.util.EObjectWithInverseResolvingEList;
import org.eclipse.emf.ecore.util.InternalEList;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Host Instance</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getId <em>Id</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getNodeIp <em>Node Ip</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getAvailableCpu <em>Available Cpu</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getAvailableRam <em>Available Ram</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getAvailableHdd <em>Available Hdd</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getTotalCpu <em>Total Cpu</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getTotalRam <em>Total Ram</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getTotalHdd <em>Total Hdd</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getApplications <em>Applications</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.HostInstanceImpl#getCommunicateWith <em>Communicate With</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class HostInstanceImpl extends MinimalEObjectImpl.Container implements HostInstance {
	/**
	 * The default value of the '{@link #getId() <em>Id</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getId()
	 * @generated
	 * @ordered
	 */
	protected static final String ID_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getId() <em>Id</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getId()
	 * @generated
	 * @ordered
	 */
	protected String id = ID_EDEFAULT;

	/**
	 * The default value of the '{@link #getNodeIp() <em>Node Ip</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNodeIp()
	 * @generated
	 * @ordered
	 */
	protected static final String NODE_IP_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getNodeIp() <em>Node Ip</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getNodeIp()
	 * @generated
	 * @ordered
	 */
	protected String nodeIp = NODE_IP_EDEFAULT;

	/**
	 * The default value of the '{@link #getAvailableCpu() <em>Available Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAvailableCpu()
	 * @generated
	 * @ordered
	 */
	protected static final int AVAILABLE_CPU_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getAvailableCpu() <em>Available Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAvailableCpu()
	 * @generated
	 * @ordered
	 */
	protected int availableCpu = AVAILABLE_CPU_EDEFAULT;

	/**
	 * The default value of the '{@link #getAvailableRam() <em>Available Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAvailableRam()
	 * @generated
	 * @ordered
	 */
	protected static final int AVAILABLE_RAM_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getAvailableRam() <em>Available Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAvailableRam()
	 * @generated
	 * @ordered
	 */
	protected int availableRam = AVAILABLE_RAM_EDEFAULT;

	/**
	 * The default value of the '{@link #getAvailableHdd() <em>Available Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAvailableHdd()
	 * @generated
	 * @ordered
	 */
	protected static final int AVAILABLE_HDD_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getAvailableHdd() <em>Available Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAvailableHdd()
	 * @generated
	 * @ordered
	 */
	protected int availableHdd = AVAILABLE_HDD_EDEFAULT;

	/**
	 * The default value of the '{@link #getTotalCpu() <em>Total Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTotalCpu()
	 * @generated
	 * @ordered
	 */
	protected static final int TOTAL_CPU_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getTotalCpu() <em>Total Cpu</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTotalCpu()
	 * @generated
	 * @ordered
	 */
	protected int totalCpu = TOTAL_CPU_EDEFAULT;

	/**
	 * The default value of the '{@link #getTotalRam() <em>Total Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTotalRam()
	 * @generated
	 * @ordered
	 */
	protected static final int TOTAL_RAM_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getTotalRam() <em>Total Ram</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTotalRam()
	 * @generated
	 * @ordered
	 */
	protected int totalRam = TOTAL_RAM_EDEFAULT;

	/**
	 * The default value of the '{@link #getTotalHdd() <em>Total Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTotalHdd()
	 * @generated
	 * @ordered
	 */
	protected static final int TOTAL_HDD_EDEFAULT = 0;

	/**
	 * The cached value of the '{@link #getTotalHdd() <em>Total Hdd</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getTotalHdd()
	 * @generated
	 * @ordered
	 */
	protected int totalHdd = TOTAL_HDD_EDEFAULT;

	/**
	 * The cached value of the '{@link #getApplications() <em>Applications</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getApplications()
	 * @generated
	 * @ordered
	 */
	protected EList<ApplicationInstance> applications;

	/**
	 * The cached value of the '{@link #getCommunicateWith() <em>Communicate With</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getCommunicateWith()
	 * @generated
	 * @ordered
	 */
	protected EList<HostInstance> communicateWith;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected HostInstanceImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return ModelPackage.Literals.HOST_INSTANCE;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getId() {
		return id;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setId(String newId) {
		String oldId = id;
		id = newId;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__ID, oldId, id));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getNodeIp() {
		return nodeIp;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setNodeIp(String newNodeIp) {
		String oldNodeIp = nodeIp;
		nodeIp = newNodeIp;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__NODE_IP, oldNodeIp, nodeIp));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getAvailableCpu() {
		return availableCpu;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setAvailableCpu(int newAvailableCpu) {
		int oldAvailableCpu = availableCpu;
		availableCpu = newAvailableCpu;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__AVAILABLE_CPU, oldAvailableCpu, availableCpu));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getAvailableRam() {
		return availableRam;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setAvailableRam(int newAvailableRam) {
		int oldAvailableRam = availableRam;
		availableRam = newAvailableRam;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__AVAILABLE_RAM, oldAvailableRam, availableRam));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getAvailableHdd() {
		return availableHdd;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setAvailableHdd(int newAvailableHdd) {
		int oldAvailableHdd = availableHdd;
		availableHdd = newAvailableHdd;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__AVAILABLE_HDD, oldAvailableHdd, availableHdd));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getTotalCpu() {
		return totalCpu;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTotalCpu(int newTotalCpu) {
		int oldTotalCpu = totalCpu;
		totalCpu = newTotalCpu;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__TOTAL_CPU, oldTotalCpu, totalCpu));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getTotalRam() {
		return totalRam;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTotalRam(int newTotalRam) {
		int oldTotalRam = totalRam;
		totalRam = newTotalRam;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__TOTAL_RAM, oldTotalRam, totalRam));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public int getTotalHdd() {
		return totalHdd;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setTotalHdd(int newTotalHdd) {
		int oldTotalHdd = totalHdd;
		totalHdd = newTotalHdd;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.HOST_INSTANCE__TOTAL_HDD, oldTotalHdd, totalHdd));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<ApplicationInstance> getApplications() {
		if (applications == null) {
			applications = new EObjectWithInverseResolvingEList<ApplicationInstance>(ApplicationInstance.class, this, ModelPackage.HOST_INSTANCE__APPLICATIONS, ModelPackage.APPLICATION_INSTANCE__ALLOCATED_TO);
		}
		return applications;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<HostInstance> getCommunicateWith() {
		if (communicateWith == null) {
			communicateWith = new EObjectResolvingEList<HostInstance>(HostInstance.class, this, ModelPackage.HOST_INSTANCE__COMMUNICATE_WITH);
		}
		return communicateWith;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case ModelPackage.HOST_INSTANCE__APPLICATIONS:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getApplications()).basicAdd(otherEnd, msgs);
		}
		return super.eInverseAdd(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case ModelPackage.HOST_INSTANCE__APPLICATIONS:
				return ((InternalEList<?>)getApplications()).basicRemove(otherEnd, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case ModelPackage.HOST_INSTANCE__ID:
				return getId();
			case ModelPackage.HOST_INSTANCE__NODE_IP:
				return getNodeIp();
			case ModelPackage.HOST_INSTANCE__AVAILABLE_CPU:
				return getAvailableCpu();
			case ModelPackage.HOST_INSTANCE__AVAILABLE_RAM:
				return getAvailableRam();
			case ModelPackage.HOST_INSTANCE__AVAILABLE_HDD:
				return getAvailableHdd();
			case ModelPackage.HOST_INSTANCE__TOTAL_CPU:
				return getTotalCpu();
			case ModelPackage.HOST_INSTANCE__TOTAL_RAM:
				return getTotalRam();
			case ModelPackage.HOST_INSTANCE__TOTAL_HDD:
				return getTotalHdd();
			case ModelPackage.HOST_INSTANCE__APPLICATIONS:
				return getApplications();
			case ModelPackage.HOST_INSTANCE__COMMUNICATE_WITH:
				return getCommunicateWith();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case ModelPackage.HOST_INSTANCE__ID:
				setId((String)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__NODE_IP:
				setNodeIp((String)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_CPU:
				setAvailableCpu((Integer)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_RAM:
				setAvailableRam((Integer)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_HDD:
				setAvailableHdd((Integer)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__TOTAL_CPU:
				setTotalCpu((Integer)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__TOTAL_RAM:
				setTotalRam((Integer)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__TOTAL_HDD:
				setTotalHdd((Integer)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__APPLICATIONS:
				getApplications().clear();
				getApplications().addAll((Collection<? extends ApplicationInstance>)newValue);
				return;
			case ModelPackage.HOST_INSTANCE__COMMUNICATE_WITH:
				getCommunicateWith().clear();
				getCommunicateWith().addAll((Collection<? extends HostInstance>)newValue);
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
			case ModelPackage.HOST_INSTANCE__ID:
				setId(ID_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__NODE_IP:
				setNodeIp(NODE_IP_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_CPU:
				setAvailableCpu(AVAILABLE_CPU_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_RAM:
				setAvailableRam(AVAILABLE_RAM_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_HDD:
				setAvailableHdd(AVAILABLE_HDD_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__TOTAL_CPU:
				setTotalCpu(TOTAL_CPU_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__TOTAL_RAM:
				setTotalRam(TOTAL_RAM_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__TOTAL_HDD:
				setTotalHdd(TOTAL_HDD_EDEFAULT);
				return;
			case ModelPackage.HOST_INSTANCE__APPLICATIONS:
				getApplications().clear();
				return;
			case ModelPackage.HOST_INSTANCE__COMMUNICATE_WITH:
				getCommunicateWith().clear();
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
			case ModelPackage.HOST_INSTANCE__ID:
				return ID_EDEFAULT == null ? id != null : !ID_EDEFAULT.equals(id);
			case ModelPackage.HOST_INSTANCE__NODE_IP:
				return NODE_IP_EDEFAULT == null ? nodeIp != null : !NODE_IP_EDEFAULT.equals(nodeIp);
			case ModelPackage.HOST_INSTANCE__AVAILABLE_CPU:
				return availableCpu != AVAILABLE_CPU_EDEFAULT;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_RAM:
				return availableRam != AVAILABLE_RAM_EDEFAULT;
			case ModelPackage.HOST_INSTANCE__AVAILABLE_HDD:
				return availableHdd != AVAILABLE_HDD_EDEFAULT;
			case ModelPackage.HOST_INSTANCE__TOTAL_CPU:
				return totalCpu != TOTAL_CPU_EDEFAULT;
			case ModelPackage.HOST_INSTANCE__TOTAL_RAM:
				return totalRam != TOTAL_RAM_EDEFAULT;
			case ModelPackage.HOST_INSTANCE__TOTAL_HDD:
				return totalHdd != TOTAL_HDD_EDEFAULT;
			case ModelPackage.HOST_INSTANCE__APPLICATIONS:
				return applications != null && !applications.isEmpty();
			case ModelPackage.HOST_INSTANCE__COMMUNICATE_WITH:
				return communicateWith != null && !communicateWith.isEmpty();
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
		result.append(" (id: ");
		result.append(id);
		result.append(", nodeIp: ");
		result.append(nodeIp);
		result.append(", availableCpu: ");
		result.append(availableCpu);
		result.append(", availableRam: ");
		result.append(availableRam);
		result.append(", availableHdd: ");
		result.append(availableHdd);
		result.append(", totalCpu: ");
		result.append(totalCpu);
		result.append(", totalRam: ");
		result.append(totalRam);
		result.append(", totalHdd: ");
		result.append(totalHdd);
		result.append(')');
		return result.toString();
	}

} //HostInstanceImpl
