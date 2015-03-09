package org.eclipse.incquery.examples.cps.benchmark.metrics

import java.util.concurrent.TimeUnit;

import com.google.common.base.Stopwatch
import org.eclipse.xtend.lib.annotations.Accessors

class TimerMetric extends BenchmarkMetric{
	
	var long elapsedTime
	Stopwatch stopwatch
	@Accessors var static TimeUnit unit = TimeUnit.MILLISECONDS 
	
	new(String name) {
		super(name)
	}
	
	override String getValue() {
		elapsedTime = stopwatch.elapsed(unit)
		Long.toString(elapsedTime)
	}
	
	/**
	 * Starts to measure time. Must be called before invoke getValue.
	*/
	def startMesure(){
		stopwatch = Stopwatch.createStarted()
	}
	
	/**
	 * Stops the measurement. Optional but recommended to use.
	*/
	def stopMeasure(){
		stopwatch.stop()
	}

}