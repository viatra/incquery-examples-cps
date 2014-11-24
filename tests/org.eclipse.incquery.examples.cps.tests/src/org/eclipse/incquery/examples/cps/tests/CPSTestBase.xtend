package org.eclipse.incquery.examples.cps.tests

import java.io.OutputStreamWriter
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout
import org.junit.BeforeClass

class CPSTestBase {
	
	protected val instancesDirPath = "file://" + PropertiesUtil.getGitCloneLocation + "/models/org.eclipse.incquery.examples.cps.instances/"
	
	@BeforeClass
	def static setupRootLogger() {
		Logger.getLogger("cps.xform").level = PropertiesUtil.getCPSXformLogLevel
		Logger.getLogger("cps.generator").initLoggerForLevel(PropertiesUtil.getCPSGeneratorLogLevel)
		Logger.getLogger("org.eclipse.incquery").level = PropertiesUtil.getIncQueryLogLevel
	}
	
	def static initLoggerForLevel(Logger logger, Level level) {
		var ConsoleAppender ca = new ConsoleAppender();
		ca.setWriter(new OutputStreamWriter(System.out));
		ca.setLayout(new PatternLayout("%c{1}:%L - %m%n"));
		logger.setAdditivity(false);
		logger.removeAllAppenders();
		logger.addAppender(ca);
		logger.setLevel(level);
	}
}
