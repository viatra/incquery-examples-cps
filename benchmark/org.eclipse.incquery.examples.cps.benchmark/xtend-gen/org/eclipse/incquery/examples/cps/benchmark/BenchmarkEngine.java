package org.eclipse.incquery.examples.cps.benchmark;

import org.eclipse.incquery.examples.cps.benchmark.results.BenchmarkResult;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class BenchmarkEngine {
  @Accessors({ AccessorType.PUBLIC_GETTER, AccessorType.NONE })
  private BenchmarkResult benchmarkResult;
  
  public BenchmarkEngine() {
    BenchmarkResult _benchmarkResult = new BenchmarkResult();
    this.benchmarkResult = _benchmarkResult;
  }
  
  public void runBenchmark() {
    int iteration = 1;
  }
  
  @Pure
  public BenchmarkResult getBenchmarkResult() {
    return this.benchmarkResult;
  }
}
