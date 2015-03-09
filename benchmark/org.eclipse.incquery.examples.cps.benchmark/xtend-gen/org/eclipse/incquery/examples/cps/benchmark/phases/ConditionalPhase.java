package org.eclipse.incquery.examples.cps.benchmark.phases;

import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public abstract class ConditionalPhase implements BenchmarkPhase {
  @Accessors
  protected BenchmarkPhase phase;
  
  public abstract boolean condition();
  
  @Pure
  public BenchmarkPhase getPhase() {
    return this.phase;
  }
  
  public void setPhase(final BenchmarkPhase phase) {
    this.phase = phase;
  }
}
