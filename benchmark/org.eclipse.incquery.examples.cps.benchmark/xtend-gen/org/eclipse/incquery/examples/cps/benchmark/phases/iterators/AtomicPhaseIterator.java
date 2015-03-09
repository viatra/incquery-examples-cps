package org.eclipse.incquery.examples.cps.benchmark.phases.iterators;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;

@SuppressWarnings("all")
public class AtomicPhaseIterator implements Iterator<BenchmarkPhase> {
  private AtomicPhase atomic;
  
  private boolean hasNext;
  
  public AtomicPhaseIterator(final AtomicPhase phase) {
    this.atomic = phase;
    this.hasNext = true;
  }
  
  public boolean hasNext() {
    return this.hasNext;
  }
  
  public BenchmarkPhase next() {
    AtomicPhase _xblockexpression = null;
    {
      this.hasNext = false;
      _xblockexpression = this.atomic;
    }
    return _xblockexpression;
  }
  
  public void remove() {
    throw new UnsupportedOperationException("Unsupported operation");
  }
}
