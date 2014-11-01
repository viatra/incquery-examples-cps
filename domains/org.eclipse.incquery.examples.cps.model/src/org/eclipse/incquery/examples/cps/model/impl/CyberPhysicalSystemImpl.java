/**
 */
package org.eclipse.incquery.examples.cps.model.impl;

import org.eclipse.incquery.examples.cps.model.ApplicationInstance;
import org.eclipse.incquery.examples.cps.model.ApplicationType;
import org.eclipse.incquery.examples.cps.model.CyberPhysicalSystem;
import org.eclipse.incquery.examples.cps.model.HostInstance;
import org.eclipse.incquery.examples.cps.model.HostType;
import org.eclipse.incquery.examples.cps.model.ModelPackage;
import org.eclipse.incquery.examples.cps.model.Request;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.EObjectContainmentWithInverseEList;
import org.eclipse.emf.ecore.util.InternalEList;
import org.eclipse.incquery.querybasedfeatures.runtime.IQueryBasedFeatureHandler;
import org.eclipse.incquery.querybasedfeatures.runtime.QueryBasedFeatureKind;
import org.eclipse.incquery.querybasedfeatures.runtime.QueryBasedFeatureHelper;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Cyber Physical System</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getId <em>Id</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getDbUrl <em>Db Url</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getAppTypes <em>App Types</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getRequests <em>Requests</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getHostTypes <em>Host Types</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getHostInstances <em>Host Instances</em>}</li>
 *   <li>{@link org.eclipse.incquery.examples.cps.model.impl.CyberPhysicalSystemImpl#getAppInstances <em>App Instances</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class CyberPhysicalSystemImpl extends MinimalEObjectImpl.Container implements CyberPhysicalSystem {
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
	 * The default value of the '{@link #getDbUrl() <em>Db Url</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDbUrl()
	 * @generated
	 * @ordered
	 */
	protected static final String DB_URL_EDEFAULT = null;

	/**
	 * The cached value of the '{@link #getDbUrl() <em>Db Url</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getDbUrl()
	 * @generated
	 * @ordered
	 */
	protected String dbUrl = DB_URL_EDEFAULT;

	/**
	 * The cached value of the '{@link #getAppTypes() <em>App Types</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAppTypes()
	 * @generated
	 * @ordered
	 */
	protected EList<ApplicationType> appTypes;

	/**
	 * The cached value of the '{@link #getRequests() <em>Requests</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getRequests()
	 * @generated
	 * @ordered
	 */
	protected EList<Request> requests;

	/**
	 * The cached value of the '{@link #getHostTypes() <em>Host Types</em>}' containment reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getHostTypes()
	 * @generated
	 * @ordered
	 */
	protected EList<HostType> hostTypes;

	/**
	 * The cached setting delegate for the '{@link #getHostInstances() <em>Host Instances</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getHostInstances()
	 * @generated
	 * @ordered
	 */
	protected EStructuralFeature.Internal.SettingDelegate HOST_INSTANCES__ESETTING_DELEGATE = ((EStructuralFeature.Internal)ModelPackage.Literals.CYBER_PHYSICAL_SYSTEM__HOST_INSTANCES).getSettingDelegate();

	/**
	 * The cached setting delegate for the '{@link #getAppInstances() <em>App Instances</em>}' reference list.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getAppInstances()
	 * @generated
	 * @ordered
	 */
	protected EStructuralFeature.Internal.SettingDelegate APP_INSTANCES__ESETTING_DELEGATE = ((EStructuralFeature.Internal)ModelPackage.Literals.CYBER_PHYSICAL_SYSTEM__APP_INSTANCES).getSettingDelegate();

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected CyberPhysicalSystemImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return ModelPackage.Literals.CYBER_PHYSICAL_SYSTEM;
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
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.CYBER_PHYSICAL_SYSTEM__ID, oldId, id));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public String getDbUrl() {
		return dbUrl;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public void setDbUrl(String newDbUrl) {
		String oldDbUrl = dbUrl;
		dbUrl = newDbUrl;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, ModelPackage.CYBER_PHYSICAL_SYSTEM__DB_URL, oldDbUrl, dbUrl));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<ApplicationType> getAppTypes() {
		if (appTypes == null) {
			appTypes = new EObjectContainmentWithInverseEList<ApplicationType>(ApplicationType.class, this, ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES, ModelPackage.APPLICATION_TYPE__CPS);
		}
		return appTypes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<Request> getRequests() {
		if (requests == null) {
			requests = new EObjectContainmentEList<Request>(Request.class, this, ModelPackage.CYBER_PHYSICAL_SYSTEM__REQUESTS);
		}
		return requests;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public EList<HostType> getHostTypes() {
		if (hostTypes == null) {
			hostTypes = new EObjectContainmentWithInverseEList<HostType>(HostType.class, this, ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES, ModelPackage.HOST_TYPE__CPS);
		}
		return hostTypes;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	public EList<HostInstance> getHostInstancesGen() {
		return (EList<HostInstance>)HOST_INSTANCES__ESETTING_DELEGATE.dynamicGet(this, null, 0, true, false);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	public EList<ApplicationInstance> getAppInstancesGen() {
		return (EList<ApplicationInstance>)APP_INSTANCES__ESETTING_DELEGATE.dynamicGet(this, null, 0, true, false);
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
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getAppTypes()).basicAdd(otherEnd, msgs);
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES:
				return ((InternalEList<InternalEObject>)(InternalEList<?>)getHostTypes()).basicAdd(otherEnd, msgs);
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
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES:
				return ((InternalEList<?>)getAppTypes()).basicRemove(otherEnd, msgs);
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__REQUESTS:
				return ((InternalEList<?>)getRequests()).basicRemove(otherEnd, msgs);
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES:
				return ((InternalEList<?>)getHostTypes()).basicRemove(otherEnd, msgs);
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
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__ID:
				return getId();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__DB_URL:
				return getDbUrl();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES:
				return getAppTypes();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__REQUESTS:
				return getRequests();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES:
				return getHostTypes();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_INSTANCES:
				return getHostInstances();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_INSTANCES:
				return getAppInstances();
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
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__ID:
				setId((String)newValue);
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__DB_URL:
				setDbUrl((String)newValue);
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES:
				getAppTypes().clear();
				getAppTypes().addAll((Collection<? extends ApplicationType>)newValue);
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__REQUESTS:
				getRequests().clear();
				getRequests().addAll((Collection<? extends Request>)newValue);
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES:
				getHostTypes().clear();
				getHostTypes().addAll((Collection<? extends HostType>)newValue);
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
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__ID:
				setId(ID_EDEFAULT);
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__DB_URL:
				setDbUrl(DB_URL_EDEFAULT);
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES:
				getAppTypes().clear();
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__REQUESTS:
				getRequests().clear();
				return;
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES:
				getHostTypes().clear();
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
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__ID:
				return ID_EDEFAULT == null ? id != null : !ID_EDEFAULT.equals(id);
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__DB_URL:
				return DB_URL_EDEFAULT == null ? dbUrl != null : !DB_URL_EDEFAULT.equals(dbUrl);
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_TYPES:
				return appTypes != null && !appTypes.isEmpty();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__REQUESTS:
				return requests != null && !requests.isEmpty();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_TYPES:
				return hostTypes != null && !hostTypes.isEmpty();
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__HOST_INSTANCES:
				return HOST_INSTANCES__ESETTING_DELEGATE.dynamicIsSet(this, null, 0);
			case ModelPackage.CYBER_PHYSICAL_SYSTEM__APP_INSTANCES:
				return APP_INSTANCES__ESETTING_DELEGATE.dynamicIsSet(this, null, 0);
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
		result.append(", dbUrl: ");
		result.append(dbUrl);
		result.append(')');
		return result.toString();
	}

	/**
	 * EMF-IncQuery handler for query-based feature appInstances
	 */
	private IQueryBasedFeatureHandler appInstancesHandler;

	/**
	 * <!-- begin-user-doc --> <!-- end-user-doc -->
	 * @query-based getter created by EMF-IncQuery for query-based feature appInstances
	 */
	@SuppressWarnings("unchecked")
	public EList<ApplicationInstance> getAppInstances() {
		if (appInstancesHandler == null) {
			appInstancesHandler = QueryBasedFeatureHelper
					.getQueryBasedFeatureHandler(
							this,
							ModelPackageImpl.Literals.CYBER_PHYSICAL_SYSTEM__APP_INSTANCES,
							"org.eclipse.incquery.examples.cps.model.derived.getAppInstances",
							"cps", "app", QueryBasedFeatureKind.MANY_REFERENCE,
							true, false);
		}
		return appInstancesHandler.getManyReferenceValueAsEList(this);
	}

	/**
	 * EMF-IncQuery handler for query-based feature hostInstances
	 */
	private IQueryBasedFeatureHandler hostInstancesHandler;

	/**
	 * <!-- begin-user-doc --> <!-- end-user-doc -->
	 * @query-based getter created by EMF-IncQuery for query-based feature hostInstances
	 */
	@SuppressWarnings("unchecked")
	public EList<HostInstance> getHostInstances() {
		if (hostInstancesHandler == null) {
			hostInstancesHandler = QueryBasedFeatureHelper
					.getQueryBasedFeatureHandler(
							this,
							ModelPackageImpl.Literals.CYBER_PHYSICAL_SYSTEM__HOST_INSTANCES,
							"org.eclipse.incquery.examples.cps.model.derived.hostInstances",
							"cps", "host",
							QueryBasedFeatureKind.MANY_REFERENCE, true, false);
		}
		return hostInstancesHandler.getManyReferenceValueAsEList(this);
	}

} //CyberPhysicalSystemImpl
