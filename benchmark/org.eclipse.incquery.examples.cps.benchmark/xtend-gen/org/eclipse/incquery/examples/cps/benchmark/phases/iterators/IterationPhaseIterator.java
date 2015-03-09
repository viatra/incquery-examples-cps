package org.eclipse.incquery.examples.cps.benchmark.phases.iterators;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.IterationPhase;

@SuppressWarnings("all")
public class IterationPhaseIterator implements Iterator<BenchmarkPhase> {
  private int maxIteration;
  
  private int iteration;
  
  private IterationPhase iterationPhase;
  
  private Iterator<BenchmarkPhase> iterator;
  
  public IterationPhaseIterator(final IterationPhase iterationPhase) {
    this.iterationPhase = iterationPhase;
    this.iteration = 0;
    int _maxIteration = iterationPhase.getMaxIteration();
    this.maxIteration = _maxIteration;
    BenchmarkPhase _phase = iterationPhase.getPhase();
    Iterator<BenchmarkPhase> _iterator = _phase.iterator();
    this.iterator = _iterator;
  }
  
  public boolean hasNext() {
    return (this.iteration < this.maxIteration);
  }
  
  public BenchmarkPhase next() {
    if ((this.iteration == this.maxIteration)) {
      this.iteration = 0;
    }
    final BenchmarkPhase atomic = this.iterator.next();
    boolean _hasNext = this.iterator.hasNext();
    boolean _not = (!_hasNext);
    if (_not) {
      this.iteration++;
    }
    return atomic;
  }
  
  public void remove() {
    throw new UnsupportedOperationException("Unsupported operation");
  }
}
