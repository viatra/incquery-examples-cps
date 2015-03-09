package org.eclipse.incquery.examples.cps.benchmark.metrics;

import com.google.common.base.Stopwatch;
import java.util.concurrent.TimeUnit;
import org.eclipse.incquery.examples.cps.benchmark.metrics.BenchmarkMetric;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class TimerMetric extends BenchmarkMetric {
  private long elapsedTime;
  
  private Stopwatch stopwatch;
  
  @Accessors
  private static TimeUnit unit = TimeUnit.MILLISECONDS;
  
  public TimerMetric(final String name) {
    super(name);
  }
  
  public String getValue() {
    String _xblockexpression = null;
    {
      long _elapsed = this.stopwatch.elapsed(TimerMetric.unit);
      this.elapsedTime = _elapsed;
      _xblockexpression = Long.toString(this.elapsedTime);
    }
    return _xblockexpression;
  }
  
  /**
   * Starts to measure time. Must be called before invoke getValue.
   */
  public Stopwatch startMesure() {
    Stopwatch _createStarted = Stopwatch.createStarted();
    return this.stopwatch = _createStarted;
  }
  
  /**
   * Stops the measurement. Optional but recommended to use.
   */
  public Stopwatch stopMeasure() {
    return this.stopwatch.stop();
  }
  
  @Pure
  public static TimeUnit getUnit() {
    return TimerMetric.unit;
  }
  
  public static void setUnit(final TimeUnit unit) {
    TimerMetric.unit = unit;
  }
}
