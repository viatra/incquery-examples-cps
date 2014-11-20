package org.eclipse.incquery.examples.cps.generator.impl.utils

import java.util.Collection
import java.util.Random
import org.eclipse.incquery.examples.cps.generator.exceptions.ModelGeneratorException
import org.eclipse.incquery.examples.cps.generator.impl.dtos.MinMaxData
import org.eclipse.incquery.examples.cps.generator.impl.dtos.Percentage

class RandomUtils {
	/**
	 * Returns a pseudo-random number between min and max, inclusive.
	 * The difference between min and max can be at most
	 * <code>Integer.MAX_VALUE - 1</code>.
	 *
	 * @param minMaxData Minimum and Maximum value (Must be greater than min.)
	 * @param seed seed of the Random class
	 * @return Integer between min and max, inclusive.
	 * @see Random#nextInt(int)
	 */
	def int randInt(MinMaxData<Integer> minMaxData, Random rand) throws ModelGeneratorException {
		if(minMaxData == null){
			throw new ModelGeneratorException("MinMaxData is null. (randInt(long seed, int min, int max))");
		}
		
		val min = minMaxData.minValue;
		val max = minMaxData.maxValue;
		
		if(min > max){
			throw new ModelGeneratorException("Max must be greater then min. (randInt(MinMaxData<Integer> minMaxData = ["+minMaxData.minValue+", "+minMaxData.maxValue+"] , Random rand))");
		}
		
	    return rand.nextInt((max - min) + 1) + min;
	}
	
	def int randIntZeroToMax(int max, Random rand) throws ModelGeneratorException {
		return randInt(new MinMaxData<Integer>(0, max), rand);
	}
	
	def int randIntExcept(MinMaxData<Integer> minMaxData, int excepted, Random rand) throws ModelGeneratorException {
		if(minMaxData.minValue == minMaxData.maxValue){
			return minMaxData.minValue;
		}
		
		var randNumber = randInt(minMaxData, rand);
		while(randNumber == excepted){
			randNumber = randInt(minMaxData, rand);
		}
		return randNumber;	
	}
	
	def <ListElement>randElement(Collection<ListElement> list, Random rand) throws ModelGeneratorException {
		if(list.empty){
			throw new ModelGeneratorException("The specified list is empty. (randElement(List list, Random rand))");
		}
		
		val max = list.size-1;
		
		val randNumber = rand.nextInt((max - 0) + 1) + 0;
		
	    return list.get(randNumber);
	}
	
	def <ListElement>randElementExcept(Collection<ListElement> list, Collection<ListElement> excepted, Random rand) throws ModelGeneratorException {
		if(excepted.containsAll(list)){
			return null;
		}
		
		if(list.size == 1){
			return list.get(0);
		}
		
		var randElement = randElement(list, rand);
		while(excepted.contains(randElement)){
			randElement = randElement(list, rand);
		}
		return randElement;	
	}
	
	def boolean randBooleanWithPercentageOfTrue(Percentage percentageOfTrue, Random rand){
		val chance = rand.nextFloat;
		return chance < percentageOfTrue.fraction;
	}

}