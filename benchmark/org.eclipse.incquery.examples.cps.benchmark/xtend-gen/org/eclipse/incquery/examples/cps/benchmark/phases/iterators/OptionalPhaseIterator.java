package org.eclipse.incquery.examples.cps.benchmark.phases.iterators;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.OptionalPhase;

@SuppressWarnings("all")
public class OptionalPhaseIterator implements Iterator<BenchmarkPhase> {
  private OptionalPhase optionalPhase;
  
  private Iterator<BenchmarkPhase> iterator;
  
  private boolean hasNext;
  
  public OptionalPhaseIterator(final OptionalPhase optionalPhase) {
    this.optionalPhase = optionalPhase;
    this.hasNext = true;
    BenchmarkPhase _phase = optionalPhase.getPhase();
    Iterator<BenchmarkPhase> _iterator = _phase.iterator();
    this.iterator = _iterator;
  }
  
  public boolean hasNext() {
    return this.hasNext;
  }
  
  public BenchmarkPhase next() {
    boolean _condition = this.optionalPhase.condition();
    if (_condition) {
      final BenchmarkPhase atomic = this.iterator.next();
      boolean _hasNext = this.iterator.hasNext();
      boolean _not = (!_hasNext);
      if (_not) {
        this.hasNext = false;
      }
      return atomic;
    }
    this.hasNext = false;
    return null;
  }
  
  public void remove() {
    throw new UnsupportedOperationException("Unsupported operation");
  }
}
