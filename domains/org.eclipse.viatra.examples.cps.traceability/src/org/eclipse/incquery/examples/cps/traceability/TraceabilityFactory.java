/**
 */
package org.eclipse.incquery.examples.cps.traceability;

import org.eclipse.emf.ecore.EFactory;

/**
 * <!-- begin-user-doc -->
 * The <b>Factory</b> for the model.
 * It provides a create method for each non-abstract class of the model.
 * <!-- end-user-doc -->
 * @see org.eclipse.incquery.examples.cps.traceability.TraceabilityPackage
 * @generated
 */
public interface TraceabilityFactory extends EFactory {
	/**
	 * The singleton instance of the factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	TraceabilityFactory eINSTANCE = org.eclipse.incquery.examples.cps.traceability.impl.TraceabilityFactoryImpl.init();

	/**
	 * Returns a new object of class '<em>CPS To Deployment</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>CPS To Deployment</em>'.
	 * @generated
	 */
	CPSToDeployment createCPSToDeployment();

	/**
	 * Returns a new object of class '<em>CPS2 Deplyoment Trace</em>'.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return a new object of class '<em>CPS2 Deplyoment Trace</em>'.
	 * @generated
	 */
	CPS2DeplyomentTrace createCPS2DeplyomentTrace();

	/**
	 * Returns the package supported by this factory.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the package supported by this factory.
	 * @generated
	 */
	TraceabilityPackage getTraceabilityPackage();

} //TraceabilityFactory
