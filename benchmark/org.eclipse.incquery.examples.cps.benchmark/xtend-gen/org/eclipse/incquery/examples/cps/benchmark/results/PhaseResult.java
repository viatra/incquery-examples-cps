package org.eclipse.incquery.examples.cps.benchmark.results;

import java.util.ArrayList;
import java.util.List;
import org.codehaus.jackson.annotate.JsonProperty;
import org.eclipse.incquery.examples.cps.benchmark.metrics.BenchmarkMetric;
import org.eclipse.incquery.examples.cps.benchmark.results.MetricResult;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class PhaseResult {
  @JsonProperty("Name")
  @Accessors
  private String name;
  
  @JsonProperty("Sequence")
  @Accessors
  private int sequence;
  
  @JsonProperty("Metrics")
  private List<MetricResult> metricResults;
  
  public PhaseResult() {
    ArrayList<MetricResult> _arrayList = new ArrayList<MetricResult>();
    this.metricResults = _arrayList;
  }
  
  public void addMetrics(final BenchmarkMetric... metrics) {
    final Procedure1<BenchmarkMetric> _function = new Procedure1<BenchmarkMetric>() {
      public void apply(final BenchmarkMetric metric) {
        String _name = metric.getName();
        String _value = metric.getValue();
        final MetricResult result = new MetricResult(_name, _value);
        PhaseResult.this.metricResults.add(result);
      }
    };
    IterableExtensions.<BenchmarkMetric>forEach(((Iterable<BenchmarkMetric>)Conversions.doWrapArray(metrics)), _function);
  }
  
  @Pure
  public String getName() {
    return this.name;
  }
  
  public void setName(final String name) {
    this.name = name;
  }
  
  @Pure
  public int getSequence() {
    return this.sequence;
  }
  
  public void setSequence(final int sequence) {
    this.sequence = sequence;
  }
}
