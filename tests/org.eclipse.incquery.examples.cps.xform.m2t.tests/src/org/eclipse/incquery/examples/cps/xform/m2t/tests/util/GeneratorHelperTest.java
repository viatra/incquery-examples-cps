package org.eclipse.incquery.examples.cps.xform.m2t.tests.util;


import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.incquery.examples.cps.tests.CPSTestBase;
import org.eclipse.incquery.examples.cps.xform.m2t.util.GeneratorHelper;
import org.junit.Ignore;
import org.junit.Test;

public class GeneratorHelperTest extends CPSTestBase{

	private static final String TEST_FILE_CONTENT = "TestTets Test Apple";
	private static final String TEST_FILE_NAME = "test.java";
	private static final String TEST_CONSTANT = "Test Test Test File Apple";
	private static Logger logger = Logger.getLogger("cps.xform.m2t.test");
	
	@Test
	public void charSeqCheckSum(){
		String testStr = TEST_FILE_CONTENT;
		long checkSum = GeneratorHelper.calculateCharSequenceCheckSum(testStr);
		
		assertEquals(1196492563, checkSum);
		
		logger.info(checkSum);
	}
	
	@Test
	public void fileCheckSum() throws IOException{
		File file = new File("test-files/test.file");
		long checkSum = GeneratorHelper.calculateFileCheckSum(file);
		
		logger.info(checkSum);

		assertEquals(1196492563, checkSum);
	}

	@Test
	public void createProject() throws CoreException, IOException {
		IProject project = GeneratorHelper.createProject("org.alma.test");

		assertTrue("Project does not exist!", project.exists());
		
	}

	@Test
	public void createFile() throws CoreException, IOException {
		createTestFile();
	}
	
	@Ignore("Transient problems when running all tests")
	@Test
	public void testCheckSums() throws CoreException, IOException {
		IFile file = createTestFile();
		
		long fileCheckSum = GeneratorHelper.calculateFileCheckSum(file);
		long contentCheckSum = GeneratorHelper.calculateCharSequenceCheckSum(TEST_CONSTANT);
		
		assertEquals(contentCheckSum, fileCheckSum);
	}
	
	@Test
	public void writeFile() throws CoreException, IOException {
		// Create test file
		IFile file = createTestFile();
		
		long localTimeStamp = file.getModificationStamp();
		
		// Try to create existing file with same content
		IFile createdFile = GeneratorHelper.createFile((IFolder)file.getParent(), TEST_FILE_NAME, 
								false, TEST_CONSTANT, true);
		// Check modification stamp
		long newTimeStamp = file.getModificationStamp();
		
		assertEquals(file, createdFile);
		assertEquals(newTimeStamp, localTimeStamp);

		
		// Modify
		IFile modifiedFile = GeneratorHelper.createFile((IFolder)file.getParent(), TEST_FILE_NAME, 
				false, "Modified content", true);

		assertTrue(localTimeStamp != file.getModificationStamp());
		assertEquals(file, modifiedFile);		
	}
	

	private IFile createTestFile() throws CoreException, IOException {
		IProject project = GeneratorHelper.createProject("org.alma.test");
		assertTrue("Project does not exist!", project.exists());
		

		IFolder srcFolder = project.getFolder("src");
		NullProgressMonitor monitor = new NullProgressMonitor();
		if(!srcFolder.exists()){
			srcFolder.create(true, true, monitor);
		}
		
		assertTrue("Folder does not exist!", srcFolder.exists());
		
		IFile createdFile = GeneratorHelper.createFile(srcFolder, TEST_FILE_NAME, false, TEST_CONSTANT, false);
		
		assertTrue("File does not exist!", createdFile.exists());
		
		return createdFile;
	}
	
	
}