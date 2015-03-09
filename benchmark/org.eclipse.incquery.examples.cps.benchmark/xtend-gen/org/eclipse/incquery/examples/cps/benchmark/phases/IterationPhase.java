package org.eclipse.incquery.examples.cps.benchmark.phases;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.IterationPhaseIterator;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class IterationPhase implements BenchmarkPhase {
  @Accessors
  protected int maxIteration;
  
  @Accessors
  protected BenchmarkPhase phase;
  
  public IterationPhase(final int maxIteration) {
    this.maxIteration = maxIteration;
  }
  
  public Iterator<BenchmarkPhase> iterator() {
    return new IterationPhaseIterator(this);
  }
  
  @Pure
  public int getMaxIteration() {
    return this.maxIteration;
  }
  
  public void setMaxIteration(final int maxIteration) {
    this.maxIteration = maxIteration;
  }
  
  @Pure
  public BenchmarkPhase getPhase() {
    return this.phase;
  }
  
  public void setPhase(final BenchmarkPhase phase) {
    this.phase = phase;
  }
}
