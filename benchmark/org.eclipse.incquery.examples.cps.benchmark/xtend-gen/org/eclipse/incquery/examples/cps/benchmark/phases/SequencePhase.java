package org.eclipse.incquery.examples.cps.benchmark.phases;

import java.util.Iterator;
import java.util.LinkedList;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.SequencePhaseIterator;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class SequencePhase implements BenchmarkPhase {
  @Accessors({ AccessorType.PUBLIC_GETTER, AccessorType.NONE })
  protected LinkedList<BenchmarkPhase> phases;
  
  public SequencePhase() {
    LinkedList<BenchmarkPhase> _linkedList = new LinkedList<BenchmarkPhase>();
    this.phases = _linkedList;
  }
  
  public void addPhase(final BenchmarkPhase... phases) {
    final Procedure1<BenchmarkPhase> _function = new Procedure1<BenchmarkPhase>() {
      public void apply(final BenchmarkPhase phase) {
        SequencePhase.this.phases.add(phase);
      }
    };
    IterableExtensions.<BenchmarkPhase>forEach(((Iterable<BenchmarkPhase>)Conversions.doWrapArray(phases)), _function);
  }
  
  public Iterator<BenchmarkPhase> iterator() {
    return new SequencePhaseIterator(this);
  }
  
  public int getSize() {
    return this.phases.size();
  }
  
  @Pure
  public LinkedList<BenchmarkPhase> getPhases() {
    return this.phases;
  }
}
