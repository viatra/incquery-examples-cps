package org.eclipse.incquery.examples.cps.performance.tests.config;

import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchIncQuery;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchOptimized;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchSimple;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.BatchViatra;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.CPSTransformationWrapper;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ExplicitTraceability;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.PartialBatch;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.QueryResultTraceability;
import org.eclipse.incquery.examples.cps.xform.m2m.tests.wrappers.ViatraTransformation;

public enum TransformationType {
    BATCH_SIMPLE {public CPSTransformationWrapper getWrapper() {return new BatchSimple();}},
    BATCH_OPTIMIZED {public CPSTransformationWrapper getWrapper() {return new BatchOptimized();}},
    BATCH_INCQUERY {public CPSTransformationWrapper getWrapper() {return new BatchIncQuery();}},
    BATCH_VIATRA {public CPSTransformationWrapper getWrapper() {return new BatchViatra();}},
    INCR_QUERY_RESULT_TRACEABILITY {public CPSTransformationWrapper getWrapper() {return new QueryResultTraceability();}},
    INCR_EXPLICIT_TRACEABILITY {public CPSTransformationWrapper getWrapper() {return new ExplicitTraceability();}},
    INCR_AGGREGATED {public CPSTransformationWrapper getWrapper() {return new PartialBatch();}},
    INCR_VIATRA {public CPSTransformationWrapper getWrapper() {return new ViatraTransformation();}};
    
    public abstract CPSTransformationWrapper getWrapper();
}
