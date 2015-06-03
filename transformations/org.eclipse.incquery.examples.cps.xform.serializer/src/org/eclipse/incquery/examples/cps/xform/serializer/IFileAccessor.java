package org.eclipse.incquery.examples.cps.xform.serializer;

public interface IFileAccessor {
    /**
     * Create the specified file and fill it with the provided content
     * 
     * @param fileName File path using / to separate
     * @param contents Contents of the file
     */
    public void createFile(String folderPath, String fileName, CharSequence contents);
    
    
    /**
     * Delete the specified file
     * 
     * @param fileName File path using / to separate
     */
    public void deleteFile(String folderPath, String fileName);
    
    /**
     * Created folder
     * 
     * @param folderPath
     * @param folderName
     * @param isProject
     */
    public void createFolder(String folderPath, String folderName);
    
    /**
     * Create project folder with metadata
     * 
     * @param projectPath
     * @param projectName
     */
    public void createProject(String projectPath, String projectName);
    

}
