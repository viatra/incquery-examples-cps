package org.eclipse.viatra.examples.cps.rcpapplication.headless;

import java.io.File;
import java.util.Map;
import org.apache.log4j.FileAppender;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.eclipse.equinox.app.IApplication;
import org.eclipse.equinox.app.IApplicationContext;
import org.eclipse.viatra.examples.cps.performance.tests.ToolchainPerformanceStatisticsBasedTest;
import org.eclipse.viatra.examples.cps.performance.tests.config.GeneratorType;
import org.eclipse.viatra.examples.cps.performance.tests.config.TransformationType;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;

/**
 * This class controls all aspects of the application's execution
 */
@SuppressWarnings("all")
public class Application implements IApplication {
  private final static String COMMON_LAYOUT = "%c{1} - %m%n";
  
  private final static String FILE_LOG_LAYOUT_PREFIX = "[%d{MMM/dd HH:mm:ss}] ";
  
  @Extension
  private Logger logger = Logger.getLogger("cps.testrunner");
  
  /**
   * (non-Javadoc)
   * @see IApplication#start(org.eclipse.equinox.app.IApplicationContext)
   */
  @Override
  public Object start(final IApplicationContext context) throws Exception {
    this.logger.info("************ Test started ************");
    Map _arguments = context.getArguments();
    Object _get = _arguments.get("application.args");
    final String[] args = ((String[]) _get);
    TransformationType trafoType = null;
    int scale = 0;
    int runIndex = 0;
    GeneratorType generatorType = null;
    try {
      this.logger.info("************ Start parse");
      String _get_1 = args[0];
      TransformationType _valueOf = TransformationType.valueOf(_get_1);
      trafoType = _valueOf;
      String _get_2 = args[1];
      int _parseInt = Integer.parseInt(_get_2);
      scale = _parseInt;
      String _get_3 = args[2];
      GeneratorType _valueOf_1 = GeneratorType.valueOf(_get_3);
      generatorType = _valueOf_1;
      String _get_4 = args[3];
      int _parseInt_1 = Integer.parseInt(_get_4);
      runIndex = _parseInt_1;
      this.initLogger(trafoType, generatorType, scale);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("Parameters:");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("XFORM:\t\t");
      _builder.append(trafoType, "\t");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("GENERATOR:\t");
      _builder.append(generatorType, "\t");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("SCALE:\t\t");
      _builder.append(scale, "\t");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.append("RUN INDEX:\t");
      _builder.append(runIndex, "\t");
      _builder.newLineIfNotEmpty();
      _builder.append("\t");
      _builder.newLine();
      this.logger.info(_builder);
      final String warmupFolderPath = "./results/json/warmup/";
      File warmupFolder = new File(warmupFolderPath);
      boolean _exists = warmupFolder.exists();
      boolean _not = (!_exists);
      if (_not) {
        warmupFolder.mkdirs();
      }
      final String resultsFolderPath = "./results/json/";
      File resultsFolder = new File(resultsFolderPath);
      boolean _exists_1 = resultsFolder.exists();
      boolean _not_1 = (!_exists_1);
      if (_not_1) {
        resultsFolder.mkdirs();
      }
      this.runTest(trafoType, 1, generatorType, warmupFolderPath, runIndex);
      this.runTest(trafoType, scale, generatorType, resultsFolderPath, runIndex);
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception ex = (Exception)_t;
        String _message = ex.getMessage();
        this.logger.info(_message);
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    this.logger.info("************ Test finished ************");
    StringConcatenation _builder_1 = new StringConcatenation();
    _builder_1.append("---");
    _builder_1.newLine();
    _builder_1.append("---");
    _builder_1.newLine();
    _builder_1.append("---");
    _builder_1.newLine();
    this.logger.info(_builder_1);
    return IApplication.EXIT_OK;
  }
  
  private void initLogger(final TransformationType trafoType, final GeneratorType generatorType, final int scale) {
    try {
      Logger _logger = Logger.getLogger("org.eclipse.incquery");
      _logger.setLevel(Level.INFO);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("./results/log/log_");
      _builder.append(trafoType, "");
      _builder.append("_");
      _builder.append(generatorType, "");
      _builder.append("_size_");
      _builder.append(scale, "");
      _builder.append("_startedAt_");
      long _currentTimeMillis = System.currentTimeMillis();
      _builder.append(_currentTimeMillis, "");
      _builder.append(".log");
      final String logFilePath = _builder.toString();
      PatternLayout _patternLayout = new PatternLayout((Application.FILE_LOG_LAYOUT_PREFIX + Application.COMMON_LAYOUT));
      final FileAppender fileAppender = new FileAppender(_patternLayout, logFilePath, true);
      final Logger rootLogger = Logger.getRootLogger();
      rootLogger.removeAllAppenders();
      rootLogger.addAppender(fileAppender);
      rootLogger.setAdditivity(false);
      rootLogger.setLevel(Level.INFO);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public void runTest(final TransformationType trafoType, final int scale, final GeneratorType generatorType, final String resultsFolder, final int runIndex) {
    this.logger.info("************ Start class init");
    ToolchainPerformanceStatisticsBasedTest.callGCBefore();
    this.logger.info("************ Start instance init");
    ToolchainPerformanceStatisticsBasedTest test = new ToolchainPerformanceStatisticsBasedTest(trafoType, scale, generatorType, runIndex);
    test.cleanupBefore();
    this.logger.info("************ Run test");
    test.completeToolchainIntegrationTest(resultsFolder);
    this.logger.info("************ Start instance clean");
    test.cleanup();
    this.logger.info("************ Start class clean");
    ToolchainPerformanceStatisticsBasedTest.callGC();
  }
  
  /**
   * (non-Javadoc)
   * @see IApplication#stop()
   */
  @Override
  public void stop() {
  }
}
