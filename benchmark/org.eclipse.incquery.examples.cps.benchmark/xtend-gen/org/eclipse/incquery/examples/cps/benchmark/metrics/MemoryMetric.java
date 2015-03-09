package org.eclipse.incquery.examples.cps.benchmark.metrics;

import org.eclipse.incquery.examples.cps.benchmark.metrics.BenchmarkMetric;

@SuppressWarnings("all")
public class MemoryMetric extends BenchmarkMetric {
  private long memory;
  
  public MemoryMetric(final String name) {
    super(name);
  }
  
  public String getValue() {
    return Long.toString(this.memory);
  }
  
  public long measure() {
    Runtime _runtime = Runtime.getRuntime();
    long _talMemory = _runtime.totalMemory();
    Runtime _runtime_1 = Runtime.getRuntime();
    long _freeMemory = _runtime_1.freeMemory();
    long _minus = (_talMemory - _freeMemory);
    return this.memory = _minus;
  }
}
