package org.eclipse.incquery.examples.cps.benchmark.results;

import org.codehaus.jackson.annotate.JsonProperty;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class MetricResult {
  @JsonProperty("MetricName")
  @Accessors
  private String name;
  
  @JsonProperty("MetricValue")
  @Accessors
  private String value;
  
  public MetricResult(final String name, final String value) {
    this.name = name;
    this.value = value;
  }
  
  @Pure
  public String getName() {
    return this.name;
  }
  
  public void setName(final String name) {
    this.name = name;
  }
  
  @Pure
  public String getValue() {
    return this.value;
  }
  
  public void setValue(final String value) {
    this.value = value;
  }
}
