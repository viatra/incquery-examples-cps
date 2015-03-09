package org.eclipse.incquery.examples.cps.benchmark.results;

import java.util.ArrayList;
import java.util.List;
import org.codehaus.jackson.annotate.JsonProperty;
import org.eclipse.incquery.examples.cps.benchmark.results.CaseResult;
import org.eclipse.incquery.examples.cps.benchmark.results.PhaseResult;
import org.eclipse.incquery.examples.cps.benchmark.results.ResultSerializer;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtext.xbase.lib.Pure;

@SuppressWarnings("all")
public class BenchmarkResult {
  @JsonProperty("CaseResults")
  @Accessors
  private static CaseResult caseResult;
  
  @JsonProperty("PhaseResults")
  @Accessors({ AccessorType.PUBLIC_GETTER, AccessorType.NONE })
  private List<PhaseResult> phaseResults;
  
  @Accessors
  private static String path = "./results/json/";
  
  @Accessors
  private static boolean publish = true;
  
  public BenchmarkResult() {
    ArrayList<PhaseResult> _arrayList = new ArrayList<PhaseResult>();
    this.phaseResults = _arrayList;
  }
  
  public boolean addResults(final PhaseResult result) {
    return this.phaseResults.add(result);
  }
  
  public void publishResults() {
    String filePath = (BenchmarkResult.path + "testResult.json");
    if (BenchmarkResult.publish) {
      ResultSerializer.serializeToJson(this, filePath);
    }
  }
  
  @Pure
  public static CaseResult getCaseResult() {
    return BenchmarkResult.caseResult;
  }
  
  public static void setCaseResult(final CaseResult caseResult) {
    BenchmarkResult.caseResult = caseResult;
  }
  
  @Pure
  public List<PhaseResult> getPhaseResults() {
    return this.phaseResults;
  }
  
  @Pure
  public static String getPath() {
    return BenchmarkResult.path;
  }
  
  public static void setPath(final String path) {
    BenchmarkResult.path = path;
  }
  
  @Pure
  public static boolean isPublish() {
    return BenchmarkResult.publish;
  }
  
  public static void setPublish(final boolean publish) {
    BenchmarkResult.publish = publish;
  }
}
