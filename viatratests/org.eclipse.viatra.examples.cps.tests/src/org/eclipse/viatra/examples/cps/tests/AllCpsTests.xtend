/*******************************************************************************
 * Copyright (c) 2010-2016, Tamas Borbas, IncQuery Labs Ltd.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *   Tamas Borbas - initial API and implementation
 *******************************************************************************/
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