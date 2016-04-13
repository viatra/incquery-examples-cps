package org.eclipse.viatra.examples.cps.tests

import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

@RunWith(Suite)
@SuiteClasses(#[
    AnonymousVariablesCpsTest,
    APICpsTest,
    BasicCpsTest,
    FlattenedPatternCallCpsTest,
    ModelManipulationCpsTest,
    RecursionCpsTest,
    TestingFrameworkTest,
    VariableEqualityCpsTest
])
class AllCpsTests {}