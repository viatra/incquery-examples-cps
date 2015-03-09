package org.eclipse.incquery.examples.cps.benchmark.phases;

import java.util.Iterator;
import java.util.LinkedList;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class SequencePhase implements BenchmarkPhase {
  @Accessors({ AccessorType.PUBLIC_GETTER, AccessorType.NONE })
  protected LinkedList<BenchmarkPhase> phases;
  
  public SequencePhase() {
    LinkedList<BenchmarkPhase> _linkedList = new LinkedList<BenchmarkPhase>();
    this.phases = _linkedList;
  }
  
  public Iterator<BenchmarkPhase> iterator() {
    throw new UnsupportedOperationException("TODO: auto-generated method stub");
  }
  
  public int getSize() {
    return this.phases.size();
  }
  
  @Pure
  public LinkedList<BenchmarkPhase> getPhases() {
    return this.phases;
  }
}
