package org.eclipse.incquery.examples.cps.integration.eventdriven.enabler;

import org.eclipse.incquery.examples.cps.integration.SerializerTransformationStep;
import org.eclipse.incquery.examples.cps.xform.serializer.javaio.JavaIOBasedFileAccessor;

public class EnablerSerializerTransformationStep extends SerializerTransformationStep {

    @Override
    public void execute() {
        processNextEvent();

        ListBasedOutputProvider provider = new ListBasedOutputProvider(m2tOutput);
        serializer.serialize(sourceFolder, provider, new JavaIOBasedFileAccessor());

        System.out.println("Serialization completed");

        getModifierChannel().createEvent();
    }

}
