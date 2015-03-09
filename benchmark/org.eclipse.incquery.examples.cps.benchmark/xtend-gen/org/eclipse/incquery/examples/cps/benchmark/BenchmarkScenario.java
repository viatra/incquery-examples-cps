package org.eclipse.incquery.examples.cps.benchmark;

import com.google.common.base.Objects;
import java.util.Iterator;
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase;
import org.eclipse.incquery.examples.cps.benchmark.phases.BenchmarkPhase;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public abstract class BenchmarkScenario {
  private Iterator<BenchmarkPhase> iterator;
  
  @Accessors
  protected BenchmarkPhase rootPhase;
  
  public abstract void buildScenario();
  
  public boolean hasNextPhase() {
    boolean _xblockexpression = false;
    {
      boolean _equals = Objects.equal(this.iterator, null);
      if (_equals) {
        Iterator<BenchmarkPhase> _iterator = this.rootPhase.iterator();
        this.iterator = _iterator;
      }
      _xblockexpression = this.iterator.hasNext();
    }
    return _xblockexpression;
  }
  
  public AtomicPhase nextPhase() {
    AtomicPhase _xblockexpression = null;
    {
      boolean _equals = Objects.equal(this.iterator, null);
      if (_equals) {
        Iterator<BenchmarkPhase> _iterator = this.rootPhase.iterator();
        this.iterator = _iterator;
      }
      BenchmarkPhase _next = this.iterator.next();
      _xblockexpression = ((AtomicPhase) _next);
    }
    return _xblockexpression;
  }
  
  @Pure
  public BenchmarkPhase getRootPhase() {
    return this.rootPhase;
  }
  
  public void setRootPhase(final BenchmarkPhase rootPhase) {
    this.rootPhase = rootPhase;
  }
}
