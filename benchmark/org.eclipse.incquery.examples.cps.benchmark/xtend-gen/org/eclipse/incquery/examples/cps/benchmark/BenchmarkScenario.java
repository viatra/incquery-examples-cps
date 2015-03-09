package org.eclipse.incquery.examples.cps.benchmark;

import org.eclipse.incquery.examples.cps.benchmark.DataToken;

@SuppressWarnings("all")
public abstract class BenchmarkScenario {
  public abstract void buildScenario();
  
  public abstract DataToken getDataToken();
}
