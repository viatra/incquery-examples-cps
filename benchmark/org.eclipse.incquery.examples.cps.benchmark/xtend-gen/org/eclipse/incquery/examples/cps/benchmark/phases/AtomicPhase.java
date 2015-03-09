package org.eclipse.incquery.examples.cps.benchmark.phases;

import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.iterators.AtomicPhaseIterator;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public abstract class AtomicPhase implements BenchmarkPhase {
  @Accessors({ AccessorType.PUBLIC_GETTER, AccessorType.NONE })
  protected String phaseName;
  
  public AtomicPhase(final String name) {
    this.phaseName = name;
  }
  
  public Iterator<BenchmarkPhase> iterator() {
    return new AtomicPhaseIterator(this);
  }
  
  public abstract void execute();
  
  @Pure
  public String getPhaseName() {
    return this.phaseName;
  }
}
