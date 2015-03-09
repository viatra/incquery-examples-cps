package org.eclipse.incquery.examples.cps.benchmark.results;

import java.io.File;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.SerializationConfig;
import org.eclipse.incquery.examples.cps.benchmark.results.BenchmarkResult;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class ResultSerializer {
  public static void serializeToJson(final BenchmarkResult result, final String filePath) {
    try {
      final ObjectMapper mapper = new ObjectMapper();
      mapper.configure(SerializationConfig.Feature.FAIL_ON_EMPTY_BEANS, false);
      mapper.configure(SerializationConfig.Feature.INDENT_OUTPUT, true);
      mapper.configure(SerializationConfig.Feature.AUTO_DETECT_FIELDS, false);
      mapper.configure(SerializationConfig.Feature.AUTO_DETECT_GETTERS, false);
      File _file = new File(filePath);
      mapper.writeValue(_file, result);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
