package org.eclipse.incquery.examples.cps.tests

import java.io.OutputStreamWriter
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout
import org.junit.BeforeClass
import org.eclipse.incquery.examples.cps.generator.dtos.ModelStats

class CPSTestBase {
	
	protected val instancesDirPath = "file://" + PropertiesUtil.getGitCloneLocation + "/models/org.eclipse.incquery.examples.cps.instances/"
	
	@BeforeClass
	def static setupRootLogger() {
		Logger.getLogger("cps.xform").level = PropertiesUtil.getCPSXformLogLevel
		Logger.getLogger("cps.generator").initLoggerForLevel(PropertiesUtil.getCPSGeneratorLogLevel)
		Logger.getLogger("cps.performance.generator.Tests").initLoggerForLevel(PropertiesUtil.getCPSGeneratorLogLevel)
		Logger.getLogger("org.eclipse.incquery").level = PropertiesUtil.getIncQueryLogLevel
		Logger.getLogger("cps.mondosam").initLoggerForLevel(PropertiesUtil.getBenchmarkLogLevel)
		Logger.getLogger("cps.stats").initLoggerForLevel(PropertiesUtil.getStatsLogLevel)
	}
	
	def static initLoggerForLevel(Logger logger, Level level) {
		var ConsoleAppender ca = new ConsoleAppender();
		ca.setWriter(new OutputStreamWriter(System.out));
		ca.setLayout(new PatternLayout("%c{1}" + ModelStats.DELIMITER + "%m%n"));
		logger.setAdditivity(false);
		logger.removeAllAppenders();
		logger.addAppender(ca);
		logger.setLevel(level);
	}
}
