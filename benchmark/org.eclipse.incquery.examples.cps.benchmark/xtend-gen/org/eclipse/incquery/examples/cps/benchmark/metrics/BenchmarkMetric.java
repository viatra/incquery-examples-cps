package org.eclipse.incquery.examples.cps.benchmark.metrics;

import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public abstract class BenchmarkMetric {
  @Accessors
  protected String name;
  
  public BenchmarkMetric(final String name) {
    this.name = name;
  }
  
  public String toString() {
    String _value = this.getValue();
    return ((this.name + " ") + _value);
  }
  
  public abstract String getValue();
  
  @Pure
  public String getName() {
    return this.name;
  }
  
  public void setName(final String name) {
    this.name = name;
  }
}
