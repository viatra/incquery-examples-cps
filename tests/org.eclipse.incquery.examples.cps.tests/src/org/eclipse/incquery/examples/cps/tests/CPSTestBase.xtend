package org.eclipse.incquery.examples.cps.tests

import java.io.OutputStreamWriter
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats
import org.junit.BeforeClass

class CPSTestBase {
	
	protected val instancesDirPath = "file://" + PropertiesUtil.getGitCloneLocation + "/models/org.eclipse.incquery.examples.cps.instances/"
	
	val static STATS_LAYOUT = "%c{1}" + ModelStats.DELIMITER + "%m%n";
	val static COMMON_LAYOUT = "%c{1} - %m%n";
	
	@BeforeClass
	def static setupRootLogger() {
		Logger.getLogger("cps.xform").level = PropertiesUtil.getCPSXformLogLevel
		Logger.getLogger("cps.generator").initLoggerForLevel(PropertiesUtil.getCPSGeneratorLogLevel, COMMON_LAYOUT)
		Logger.getLogger("cps.performance.generator.Tests").initLoggerForLevel(PropertiesUtil.getCPSGeneratorLogLevel, COMMON_LAYOUT)
		Logger.getLogger("org.eclipse.incquery").level = PropertiesUtil.getIncQueryLogLevel
		Logger.getLogger("cps.mondosam").initLoggerForLevel(PropertiesUtil.getBenchmarkLogLevel, COMMON_LAYOUT)
		Logger.getLogger("cps.stats").initLoggerForLevel(PropertiesUtil.getStatsLogLevel, STATS_LAYOUT)
		Logger.getLogger("cps.proto").initLoggerForLevel(PropertiesUtil.getCPSGeneratorLogLevel, COMMON_LAYOUT)
	}
	
	def static initLoggerForLevel(Logger logger, Level level, String patternLayout) {
		var ConsoleAppender ca = new ConsoleAppender();
		ca.setWriter(new OutputStreamWriter(System.out));
		ca.setLayout(new PatternLayout(patternLayout));
		logger.setAdditivity(false);
		logger.removeAllAppenders();
		logger.addAppender(ca);
		logger.setLevel(level);
	}
}
