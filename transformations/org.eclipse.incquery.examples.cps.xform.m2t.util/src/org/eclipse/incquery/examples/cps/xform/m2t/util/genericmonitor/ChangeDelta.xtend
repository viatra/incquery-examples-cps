package org.eclipse.incquery.examples.cps.xform.m2t.util.genericmonitor

import com.google.common.collect.Multimap
import org.eclipse.emf.ecore.EObject
import org.eclipse.incquery.runtime.api.IPatternMatch
import org.eclipse.incquery.runtime.api.IQuerySpecification
import org.eclipse.incquery.runtime.api.IncQueryMatcher
import org.eclipse.xtend.lib.annotations.Data

/**
 * Class representing the changes in a given instance model since the last checkpoint. 
 * It contains three MultiMaps which contain the changed elements sorted
 * by the detecting QuerySpecifications.
 * 
 * @author Lunk Péter
 */
@Data class ChangeDelta {
	public Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> appeared
	public Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> updated
	public Multimap<IQuerySpecification<? extends IncQueryMatcher<IPatternMatch>>, EObject> disappeared
	public boolean deploymentChanged
}
