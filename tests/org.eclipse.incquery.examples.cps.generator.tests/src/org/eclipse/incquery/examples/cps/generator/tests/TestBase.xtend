package org.eclipse.incquery.examples.cps.generator.tests

import com.google.common.base.Stopwatch
import java.io.OutputStreamWriter
import java.util.concurrent.TimeUnit
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout
import org.eclipse.incquery.examples.cps.generator.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.queries.AppTypesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.HostTypesMatcher
import org.eclipse.incquery.examples.cps.generator.queries.Validation
import org.eclipse.incquery.examples.cps.generator.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.utils.PersistenceUtil
import org.eclipse.incquery.examples.cps.generator.utils.StatsUtil
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil
import org.junit.Before

import static org.junit.Assert.*

abstract class TestBase {
	protected extension Logger logger = Logger.getLogger("cps.generator.Tests")
	
	@Before
	def initLogger(){
		initLoggerForLevel(Level.INFO, Logger.getLogger("cps.generator"))
	}
	
	def assertInRangeAppTypes(ICPSConstraints constraints, IncQueryEngine engine) {
		val appTypesMatcher = AppTypesMatcher.on(engine);
		var int minApp = 0;
		var int maxApp = 0;
		for(appClass : constraints.applicationClasses){
			minApp += appClass.numberOfAppTypes.minValue;
			maxApp += appClass.numberOfAppTypes.maxValue;
		}
		
		assertInRange("AppTypeCount", appTypesMatcher.countMatches, minApp, maxApp)
	}
	
	protected def assertInRangeHostTypes(ICPSConstraints constraints, IncQueryEngine engine) {
		val hostTypesMatcher = HostTypesMatcher.on(engine);
		var int minHost = 0;
		var int maxHost = 0;
		for(appClass : constraints.hostClasses){
			minHost += appClass.numberOfHostTypes.minValue;
			maxHost += appClass.numberOfHostTypes.maxValue;
		}
		
		assertInRange("HostTypeCount", hostTypesMatcher.countMatches, minHost, maxHost)
	}
	
	protected def assertInRange(String variableName, int actualValue, int minExpected, int maxExpected){
		assertTrue(variableName +  " is out of range: "+actualValue+" --> [" +minExpected + ", "+ maxExpected + "]" , minExpected <= actualValue && actualValue <= maxExpected);
	}
	
	def initLoggerForLevel(Level level, Logger logger) {
		var ConsoleAppender ca = new ConsoleAppender();
		ca.setWriter(new OutputStreamWriter(System.out));
		ca.setLayout(new PatternLayout("%c{1}:%L - %m%n"));
		// TODO remove it
//		Logger.getRootLogger.removeAllAppenders;
		logger.setAdditivity(false);
		logger.removeAllAppenders();
		logger.addAppender(ca);
		logger.setLevel(level);
		if(!level.isGreaterOrEqual(Level.DEBUG)){
			// we only see EMF-IncQuery info, debug and trace messages when tracing
			IncQueryLoggingUtil.getDefaultLogger().setLevel(level);
		} else {
			IncQueryLoggingUtil.getDefaultLogger().setLevel(Level.WARN);
		}
	}
	
	def runGeneratorOn(ICPSConstraints constraints, long seed) {
		var Stopwatch fullTime = Stopwatch.createStarted;
		
		val out = CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints);		
		
		// Assertions
		assertNotNull("The output fragment is null", out);
		assertNotNull("The output model is null", out.modelRoot);

		assertInRange("NumberOfSignals", out.numberOfSignals, constraints.numberOfSignals.minValue, constraints.numberOfSignals.maxValue);
		
		val IncQueryEngine engine = IncQueryEngine.on(out.modelRoot);
		Validation.instance.prepare(engine);
		
		assertNotNull("IncQueryEngine is null", engine);
		
		//Show stats
		StatsUtil.logStats(StatsUtil.generateStats(engine, out.modelRoot), logger);
		
		assertInRangeAppTypes(constraints, engine);
		assertInRangeHostTypes(constraints, engine);
		
		// Persist model
		var Stopwatch persistTime = Stopwatch.createStarted;
		val filePath = "C:/output/model_"+System.nanoTime+".cyberphysicalsystem";
		info("  Generated Model is saved to \"" + filePath+"\"");
		PersistenceUtil.saveCPSModelToFile(out.modelRoot, filePath);
		persistTime.stop;
		info("  Persisting time: " + persistTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		fullTime.stop;
		info("Full Execution time: " + fullTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		
		return out;
	}
}