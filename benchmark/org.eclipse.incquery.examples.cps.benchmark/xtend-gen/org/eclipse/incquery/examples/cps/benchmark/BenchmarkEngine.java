package org.eclipse.incquery.examples.cps.benchmark;

import com.google.common.base.Objects;
import java.util.List;
import org.eclipse.incquery.examples.cps.benchmark.BenchmarkScenario;
import org.eclipse.incquery.examples.cps.benchmark.DataToken;
import org.eclipse.incquery.examples.cps.benchmark.phases.AtomicPhase;
import org.eclipse.incquery.examples.cps.benchmark.results.BenchmarkResult;
import org.eclipse.incquery.examples.cps.benchmark.results.MetricResult;
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class BenchmarkEngine {
  @Accessors({ AccessorType.PUBLIC_GETTER, AccessorType.NONE })
  @Extension
  private BenchmarkResult benchmarkResult;
  
  public BenchmarkEngine() {
    BenchmarkResult _benchmarkResult = new BenchmarkResult();
    this.benchmarkResult = _benchmarkResult;
  }
  
  public void runBenchmark(final BenchmarkScenario scenario) {
    int sequence = 1;
    DataToken token = scenario.getDataToken();
    token.init();
    while (scenario.hasNextPhase()) {
      {
        final AtomicPhase phase = scenario.nextPhase();
        boolean _notEquals = (!Objects.equal(phase, null));
        if (_notEquals) {
          final PhaseResult phaseResult = new PhaseResult();
          String _phaseName = phase.getPhaseName();
          phaseResult.setName(_phaseName);
          DataToken _execute = phase.execute(token, phaseResult);
          token = _execute;
          List<MetricResult> _metricResults = phaseResult.getMetricResults();
          int _size = _metricResults.size();
          boolean _greaterThan = (_size > 0);
          if (_greaterThan) {
            phaseResult.setSequence(sequence);
            this.benchmarkResult.addResults(phaseResult);
            sequence++;
          }
        }
      }
    }
    this.benchmarkResult.publishResults();
    token.destroy();
  }
  
  @Pure
  public BenchmarkResult getBenchmarkResult() {
    return this.benchmarkResult;
  }
}
