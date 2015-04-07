package org.eclipse.incquery.examples.cps.generator.dtos

import org.eclipse.xtend.lib.annotations.Data

@Data
class MinMaxData<DataType> {
	DataType minValue;
	DataType maxValue;

}