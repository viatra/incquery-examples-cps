package org.eclipse.incquery.examples.cps.benchmark.results;

import org.codehaus.jackson.annotate.JsonProperty;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class CaseResult {
  @JsonProperty("Scenario")
  @Accessors
  private String scenario;
  
  @JsonProperty("Tool")
  @Accessors
  private String tool;
  
  @JsonProperty("Size")
  @Accessors
  private int size;
  
  @JsonProperty("RunIndex")
  @Accessors
  private int runIndex;
  
  @JsonProperty("Case")
  @Accessors
  private String caseName;
  
  @Pure
  public String getScenario() {
    return this.scenario;
  }
  
  public void setScenario(final String scenario) {
    this.scenario = scenario;
  }
  
  @Pure
  public String getTool() {
    return this.tool;
  }
  
  public void setTool(final String tool) {
    this.tool = tool;
  }
  
  @Pure
  public int getSize() {
    return this.size;
  }
  
  public void setSize(final int size) {
    this.size = size;
  }
  
  @Pure
  public int getRunIndex() {
    return this.runIndex;
  }
  
  public void setRunIndex(final int runIndex) {
    this.runIndex = runIndex;
  }
  
  @Pure
  public String getCaseName() {
    return this.caseName;
  }
  
  public void setCaseName(final String caseName) {
    this.caseName = caseName;
  }
}
