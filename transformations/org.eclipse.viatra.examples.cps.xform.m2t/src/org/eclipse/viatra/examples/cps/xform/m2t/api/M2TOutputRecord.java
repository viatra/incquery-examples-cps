package org.eclipse.viatra.examples.cps.xform.m2t.api;

public class M2TOutputRecord {
    private String folderPath;
    private String fileName;
    private CharSequence content;
    private boolean isDeleted;
    
    public M2TOutputRecord(String folderPath, String fileName, CharSequence content, boolean isDeleted) {
        super();
        this.folderPath = folderPath;
        this.fileName = fileName;
        this.content = content;
        this.isDeleted = isDeleted;
    }

    public String getFolderPath() {
        return folderPath;
    }

    public void setFolderPath(String folderPath) {
        this.folderPath = folderPath;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public CharSequence getContent() {
        return content;
    }

    public void setContent(CharSequence content) {
        this.content = content;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }
    
    
    
}
