package org.eclipse.incquery.examples.cps.xform.serializer;

import org.eclipse.incquery.examples.cps.xform.m2t.api.IM2TOutputProvider;
import org.eclipse.incquery.examples.cps.xform.m2t.api.M2TOutputRecord;

public class DefaultSerializer implements ISerializer {

    @Override
    public void serialize(String folderPath, IM2TOutputProvider provider, IFileAccessor fileaccessor) {
        for (M2TOutputRecord record : provider.getOutput()) {
            if(record.isDeleted()){
                fileaccessor.deleteFile(folderPath, record.getFileName());
            }else{
                fileaccessor.createFile(folderPath, record.getFileName(), record.getContent());
            }
        }
    }

    @Override
    public void createProject(String projectPath, String projectName, IFileAccessor fileaccessor) {
        fileaccessor.createProject(projectPath, projectName);
    }

    @Override
    public void createFolder(String folderPath, String folderName, IFileAccessor fileaccessor) {
        fileaccessor.createFolder(folderPath, folderName);        
    }
    
    

}
