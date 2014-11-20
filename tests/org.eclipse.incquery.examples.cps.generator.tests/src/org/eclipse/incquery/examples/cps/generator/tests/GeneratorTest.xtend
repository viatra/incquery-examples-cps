package org.eclipse.incquery.examples.cps.generator.tests

import com.google.common.base.Stopwatch
import java.io.OutputStreamWriter
import java.util.concurrent.TimeUnit
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSGeneratorBuilder
import org.eclipse.incquery.examples.cps.generator.impl.utils.PersistenceUtil
import org.eclipse.incquery.examples.cps.generator.tests.constraints.AllocationCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.DemoCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.HostClassesCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.LargeCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.OnlyHostTypesCPSConstraints
import org.eclipse.incquery.examples.cps.generator.tests.constraints.SimpleCPSConstraints
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*
import org.eclipse.incquery.examples.cps.generator.tests.utils.CPSStats

class GeneratorTest {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Tests")
	
	@Before
	def initLogger(){
		initLoggerForLevel(Level.DEBUG)
	}

	@Test
	def void testSimple(){
		runGeneratorOn(new SimpleCPSConstraints(), 111111);
	}
	
	@Test
	def void testOnlyHostTypes(){
		runGeneratorOn(new OnlyHostTypesCPSConstraints(), 111111);
	}
	
	@Test
	def void testDemo(){
		runGeneratorOn(new DemoCPSConstraints(), 111111);
	}
	
	@Test
	def void testAllocation(){
		runGeneratorOn(new AllocationCPSConstraints(), 111111);
	}
	
	@Test
	def void testHostClasses(){
		runGeneratorOn(new HostClassesCPSConstraints(), 111111);
	}
	
	@Test
	def void testLargeModel(){
		runGeneratorOn(new LargeCPSConstraints(), 111111);
	}
	
	
	
	def runGeneratorOn(ICPSConstraints constraints, long seed) {
		var Stopwatch fullTime = Stopwatch.createStarted;
		
		val out = CPSGeneratorBuilder.buildAndGenerateModel(seed, constraints);
		
		fullTime.stop;
		info("Execution time: " + fullTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		
		// Assertions
		assertNotNull("The output fragment is null", out);
		assertNotNull("The output model is null", out.modelRoot);

		assertInRange("NumberOfSignals", out.numberOfSignals, constraints.numberOfSignals.minValue, constraints.numberOfSignals.maxValue);
		
		val IncQueryEngine engine = IncQueryEngine.on(out.modelRoot);
		Validation.instance.prepare(engine);
		
		assertNotNull("IncQueryEngine is null", engine);
		
		//Show stats
		showStats(generateStats(engine));
		
		assertInRangeAppTypes(constraints, engine);
		assertInRangeHostTypes(constraints, engine);
		
		// Persist model
		var Stopwatch persistTime = Stopwatch.createStarted;
		val filePath = "C:/output/model_"+System.nanoTime+".cyberphysicalsystem";
		info("Generated Model is saved to \"" + filePath+"\"");
		PersistenceUtil.saveCPSModelToFile(out.modelRoot, filePath);
		persistTime.stop;
		info("Persisting time: " + persistTime.elapsed(TimeUnit.MILLISECONDS) + " ms");
		
		return out;
	}
	
	def showStats(CPSStats stats) {
		info("Model Stats: ");
		info("  ApplicationTypes: " + stats.appTypeCount);
		info("  ApplicationInstances: " + stats.appInstanceCount);
		info("  HostTypes: " + stats.hostTypeCount);
		info("  HostInstances: " + stats.hostInstanceCount);
		info("  States: " + stats.stateCount);
		info("  Transitions: " + stats.transitionCount);
		info("  Allocated AppInstances: " + stats.allocatedAppCount);
		info("  Connected HostsInstances: " + stats.connectedHostCount);
		info("");
	}
	
	def generateStats(IncQueryEngine engine){
		return new CPSStats(engine);
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
	
	def assertInRangeHostTypes(ICPSConstraints constraints, IncQueryEngine engine) {
		val hostTypesMatcher = HostTypesMatcher.on(engine);
		var int minHost = 0;
		var int maxHost = 0;
		for(appClass : constraints.hostClasses){
			minHost += appClass.numberOfHostTypes.minValue;
			maxHost += appClass.numberOfHostTypes.maxValue;
		}
		
		assertInRange("HostTypeCount", hostTypesMatcher.countMatches, minHost, maxHost)
	}
	
	private def assertInRange(String variableName, int actualValue, int minExpected, int maxExpected){
		assertTrue(variableName +  " is out of range: "+actualValue+" --> [" +minExpected + ", "+ maxExpected + "]" , minExpected <= actualValue && actualValue <= maxExpected);
	}
	
	def initLoggerForLevel(Level level) {
		var ConsoleAppender ca = new ConsoleAppender();
		ca.setWriter(new OutputStreamWriter(System.out));
		ca.setLayout(new PatternLayout("%c{1}:%L - %m%n"));
		var Logger rootLogger = Logger.getRootLogger();
		rootLogger.removeAllAppenders();
		rootLogger.addAppender(ca);
		rootLogger.setLevel(level);
		if(!level.isGreaterOrEqual(Level.DEBUG)){
			// we only see EMF-IncQuery info, debug and trace messages when tracing
			IncQueryLoggingUtil.getDefaultLogger().setLevel(level);
		} else {
			IncQueryLoggingUtil.getDefaultLogger().setLevel(Level.WARN);
		}
	}
	
}