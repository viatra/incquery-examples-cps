package org.eclipse.incquery.examples.cps.benchmark.phases.iterators;

import java.util.Iterator;
import java.util.LinkedList;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.SequencePhase;

@SuppressWarnings("all")
public class SequencePhaseIterator implements Iterator<BenchmarkPhase> {
  private int index;
  
  private SequencePhase sequencePhase;
  
  private Iterator<BenchmarkPhase> iterator;
  
  public SequencePhaseIterator(final SequencePhase phase) {
    this.sequencePhase = phase;
    LinkedList<BenchmarkPhase> _phases = phase.getPhases();
    BenchmarkPhase _first = _phases.getFirst();
    Iterator<BenchmarkPhase> _iterator = _first.iterator();
    this.iterator = _iterator;
  }
  
  public boolean hasNext() {
    int size = this.sequencePhase.getSize();
    return (this.index < size);
  }
  
  public BenchmarkPhase next() {
    final int size = this.sequencePhase.getSize();
    if ((this.index == size)) {
      this.index = 0;
      LinkedList<BenchmarkPhase> _phases = this.sequencePhase.getPhases();
      BenchmarkPhase _first = _phases.getFirst();
      Iterator<BenchmarkPhase> _iterator = _first.iterator();
      this.iterator = _iterator;
    }
    final BenchmarkPhase atomic = this.iterator.next();
    boolean _hasNext = this.iterator.hasNext();
    boolean _not = (!_hasNext);
    if (_not) {
      this.index++;
      if ((this.index < size)) {
        LinkedList<BenchmarkPhase> _phases_1 = this.sequencePhase.getPhases();
        BenchmarkPhase _get = _phases_1.get(this.index);
        Iterator<BenchmarkPhase> _iterator_1 = _get.iterator();
        this.iterator = _iterator_1;
      }
    }
    return atomic;
  }
  
  public void remove() {
    throw new UnsupportedOperationException("UnSupported operation");
  }
}
