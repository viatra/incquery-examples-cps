package org.eclipse.incquery.examples.cps.benchmark.results;

import org.codehaus.jackson.annotate.JsonProperty;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class CaseResult {
  @JsonProperty("Scenario")
  @Accessors
  private static String scenario;
  
  @JsonProperty("Tool")
  @Accessors
  private static String tool = "IncQuery";
  
  @JsonProperty("Size")
  @Accessors
  private static int size;
  
  @JsonProperty("RunIndex")
  @Accessors
  private static int runIndex = 1;
  
  @JsonProperty("Case")
  @Accessors
  private static String caseName;
  
  @Pure
  public static String getScenario() {
    return CaseResult.scenario;
  }
  
  public static void setScenario(final String scenario) {
    CaseResult.scenario = scenario;
  }
  
  @Pure
  public static String getTool() {
    return CaseResult.tool;
  }
  
  public static void setTool(final String tool) {
    CaseResult.tool = tool;
  }
  
  @Pure
  public static int getSize() {
    return CaseResult.size;
  }
  
  public static void setSize(final int size) {
    CaseResult.size = size;
  }
  
  @Pure
  public static int getRunIndex() {
    return CaseResult.runIndex;
  }
  
  public static void setRunIndex(final int runIndex) {
    CaseResult.runIndex = runIndex;
  }
  
  @Pure
  public static String getCaseName() {
    return CaseResult.caseName;
  }
  
  public static void setCaseName(final String caseName) {
    CaseResult.caseName = caseName;
  }
}
