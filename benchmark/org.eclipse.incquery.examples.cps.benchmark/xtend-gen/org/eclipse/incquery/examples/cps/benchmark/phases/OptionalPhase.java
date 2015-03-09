package org.eclipse.incquery.examples.cps.benchmark.phases;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.ConditionalPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.OptionalPhaseIterator;

@SuppressWarnings("all")
public abstract class OptionalPhase extends ConditionalPhase {
  public Iterator<BenchmarkPhase> iterator() {
    return new OptionalPhaseIterator(this);
  }
}
