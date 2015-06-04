package org.eclipse.incquery.examples.cps.xform.serializer;

import org.eclipse.incquery.examples.cps.xform.m2t.api.IM2TOutputProvider;

public interface ISerializer {
    public void serialize(String folderPath, IM2TOutputProvider provider, IFileAccessor fileaccessor);
    
    public void createProject(String projectPath, String projectName, IFileAccessor fileaccessor);
    
    public void createFolder(String folderPath, String folderName, IFileAccessor fileaccessor);
}
