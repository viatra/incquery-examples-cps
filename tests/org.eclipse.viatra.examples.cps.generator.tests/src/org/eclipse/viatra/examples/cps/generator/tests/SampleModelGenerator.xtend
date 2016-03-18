package org.eclipse.viatra.examples.cps.generator.tests

import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.eclipse.viatra.examples.cps.generator.dtos.CPSFragment
import org.eclipse.viatra.examples.cps.generator.tests.constraints.DemoCPSConstraints
import org.eclipse.viatra.examples.cps.generator.utils.PersistenceUtil
import org.junit.Test
import org.eclipse.viatra.examples.cps.generator.tests.constraints.SimpleCPSConstraints
import org.junit.Ignore

@Ignore
class SampleModelGenerator extends TestBase {
	private String name = "model"

	@Test
	def void generateDemo() {
		name = "demo"
		runGeneratorOn(new DemoCPSConstraints(), 111111, true);
	}
	
	@Test
	def void generateSimple() {
		name = "simple"
		runGeneratorOn(new SimpleCPSConstraints(), 111111, true);
	}

	override persistModel(CPSFragment out) {
		var Stopwatch persistTime = Stopwatch.createStarted;
		val filePath = '''./models/«name»_«System.nanoTime».cyberphysicalsystem''';
		PersistenceUtil.saveCPSModelToFile(out.modelRoot, filePath);
		info("  Generated Model is saved to \"" + filePath+"\"");
		persistTime.stop;
		info("  Persisting time: " + persistTime.elapsed(TimeUnit.MILLISECONDS) + " ms")
	}
	
}