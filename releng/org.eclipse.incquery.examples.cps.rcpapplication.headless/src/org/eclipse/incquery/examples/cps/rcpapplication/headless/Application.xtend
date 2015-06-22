package org.eclipse.incquery.examples.cps.rcpapplication.headless

import java.util.Properties
import org.eclipse.equinox.app.IApplication
import org.eclipse.equinox.app.IApplicationContext
import org.eclipse.incquery.examples.cps.performance.tests.ToolchainPerformanceStatisticsBasedTest
import org.eclipse.incquery.examples.cps.performance.tests.config.GeneratorType
import org.eclipse.incquery.examples.cps.performance.tests.config.TransformationType
import org.eclipse.incquery.examples.cps.tests.CPSTestBase
import org.junit.runner.JUnitCore
import org.junit.runner.Result
import org.junit.runner.notification.RunListener
import java.io.File

/** 
 * This class controls all aspects of the application's execution
 */
class Application implements IApplication {
	/* (non-Javadoc)
	 * @see org.eclipse.equinox.app.IApplication#start(org.eclipse.equinox.app.IApplicationContext)
	 */
	override Object start(IApplicationContext context) throws Exception {
		println("************ Test started ************")
		val args = context.arguments.get("application.args") as String[]
		var TransformationType trafoType
		var int scale
		var GeneratorType generatorType
		
		try {
			println("************ Start parse")
			trafoType = TransformationType.valueOf(args.get(0))
			scale = Integer.parseInt(args.get(1))
			generatorType = GeneratorType.valueOf(args.get(2))
			
			var resultsFolder = new File("./results/json")
			if(!resultsFolder.exists)
				resultsFolder.mkdirs
			
			runTest(trafoType, 1, generatorType)
			runTest(trafoType, scale, generatorType)
			
		} catch (Exception ex) {
			println(ex.message)
		}
		println("************ Test finished ************")
		return IApplication.EXIT_OK
	}

	def runTest(TransformationType trafoType, int scale, GeneratorType generatorType) {
		// init class
		println("************ Start class init")
		ToolchainPerformanceStatisticsBasedTest.setupRootLogger()
		ToolchainPerformanceStatisticsBasedTest.callGCBefore()
		
		// init instance
		println("************ Start instance init")
		var test = new ToolchainPerformanceStatisticsBasedTest(trafoType, scale, generatorType)
		test.cleanupBefore()
		
		// run test
		println("************ Run test")
		test.completeToolchainIntegrationTest()
		
		// clean instance
		println("************ Start instance clean")
		test.cleanup()
		
		// clean class
		println("************ Start class clean")
		ToolchainPerformanceStatisticsBasedTest.callGC()
	}

	/* (non-Javadoc)
	 * @see org.eclipse.equinox.app.IApplication#stop()
	 */
	override void stop() {
		// nothing to do
	}

}
