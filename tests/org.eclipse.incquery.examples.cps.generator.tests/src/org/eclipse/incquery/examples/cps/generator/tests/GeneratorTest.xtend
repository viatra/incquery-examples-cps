package org.eclipse.incquery.examples.cps.generator.tests

import java.io.OutputStreamWriter
import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.apache.log4j.PatternLayout
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.CyberPhysicalSystem
import org.eclipse.incquery.examples.cps.generator.ModelGenerator
import org.eclipse.incquery.examples.cps.generator.impl.CPSPlanBuilder
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSFragment
import org.eclipse.incquery.examples.cps.generator.impl.dtos.CPSGeneratorInput
import org.eclipse.incquery.examples.cps.generator.impl.dtos.GeneratorPlan
import org.eclipse.incquery.examples.cps.generator.impl.interfaces.ICPSConstraints
import org.eclipse.incquery.examples.cps.generator.impl.utils.CPSModelBuilderUtil
import org.eclipse.incquery.examples.cps.generator.impl.utils.PersistenceUtil
import org.eclipse.incquery.examples.cps.generator.tests.constraints.SimpleCPSConstraints
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.incquery.runtime.util.IncQueryLoggingUtil
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class GeneratorTest {
	
	protected extension Logger logger = Logger.getLogger("cps.generator.Tests")
	
	@Before
	def initLogger(){
		initLoggerForLevel(Level.DEBUG)
	}

	@Test
	def testSimple(){
		runGeneratorOn(new SimpleCPSConstraints());
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

	def runGeneratorOn(ICPSConstraints constraints) {
		val CPSModelBuilderUtil mb = new CPSModelBuilderUtil;
		val cps2dep = mb.prepareEmptyModel("testModel"+System.nanoTime);
		
		assertNotNull(cps2dep);
		assertNotNull(cps2dep.cps);
		
		val CPSGeneratorInput input = new CPSGeneratorInput(111234234, constraints, cps2dep.cps);
		var GeneratorPlan plan = CPSPlanBuilder.build;
		
		var ModelGenerator<CyberPhysicalSystem, CPSFragment> generator = new ModelGenerator();
		var out = generator.generate(plan, input);
		
		
		assertNotNull("The output fragment is null", out);
		assertNotNull("The output model is null", out.modelRoot);
		
		// Persist model
		PersistenceUtil.saveCPSModelToFile(out.modelRoot, "C:/output/model_"+System.nanoTime+".cyberphysicalsystem");
		
		assertInRange("NumberOfSignals", out.numberOfSignals, constraints.numberOfSignals.minValue, constraints.numberOfSignals.maxValue);
		
		val IncQueryEngine engine = IncQueryEngine.on(out.modelRoot);
		
		assertNotNull("IncQueryEngine is null", engine);
		
		assertInRangeAppTypes(constraints, engine);
		assertInRangeHostTypes(constraints, engine);
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


}