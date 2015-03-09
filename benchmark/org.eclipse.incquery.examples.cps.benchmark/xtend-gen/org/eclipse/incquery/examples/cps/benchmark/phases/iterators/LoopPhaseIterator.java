package org.eclipse.incquery.examples.cps.benchmark.phases.iterators;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.LoopPhase;

@SuppressWarnings("all")
public class LoopPhaseIterator implements Iterator<BenchmarkPhase> {
  protected LoopPhase loopPhase;
  
  protected Iterator<BenchmarkPhase> iterator;
  
  public LoopPhaseIterator(final LoopPhase loopPhase) {
    this.loopPhase = loopPhase;
    BenchmarkPhase _phase = loopPhase.getPhase();
    Iterator<BenchmarkPhase> _iterator = _phase.iterator();
    this.iterator = _iterator;
  }
  
  public boolean hasNext() {
    return this.loopPhase.condition();
  }
  
  public BenchmarkPhase next() {
    boolean _condition = this.loopPhase.condition();
    if (_condition) {
      return this.iterator.next();
    }
    return null;
  }
  
  public void remove() {
    throw new UnsupportedOperationException("Unsupported operation");
  }
}
