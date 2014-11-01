package org.eclipse.incquery.examples.cps.xtend;

import java.io.ByteArrayInputStream;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.emf.ecore.resource.Resource;

/**
 * A helper class with static methods for file and folder creation for the
 * templates.
 * 
 */
public class GeneratorHelper {

	/**
	 * Creates a java file into the project that the parameter
	 * <code>nextTo</code> is in. The file is placed into the folder named
	 * <code>src</code>, which is expected to be exist. It creates the folder
	 * composition from the namespace hiearchy, so for example the namespace
	 * <code>hu.bme.mit.jpadatagenerator.helper</code> creates the
	 * <code>src/hu/bme/mit/jpadatagenerator/helper</code> folder if it isn't
	 * existed previously. The java file named <code>&lt;name&gt;.java</code>
	 * will be placed into this folder with the content defined by the
	 * <code>content</code> parameter, where <code>&lt;name&gt;</code> comes
	 * from the parameter <code>name</code>. The method only replaces a derived
	 * file.
	 * 
	 * @param nextTo
	 *            A resource which defines the target project of the file
	 *            creation.
	 * @param namespace
	 *            The namespace of the new java document.
	 * @param name
	 *            The name of the new java document and the new file.
	 * @param derived
	 *            The derived property of the new file.
	 * @param content
	 *            The content of the new file.
	 * @return Returns with the created file.
	 * @throws CoreException
	 *             If the folder named src doesn't exists or one of the folder
	 *             or the java file itself can not be created.
	 */
	public static IFile createJavaFile(Resource nextTo, String name,
			Boolean derived, CharSequence content) throws CoreException {
		// Getting the project from the name described in the URI of the
		// resource
		IProject project = ResourcesPlugin.getWorkspace().getRoot()
				.getProject(nextTo.getURI().segment(1));
		// Getting the default source folder in the project called "src-gen"
		IFolder targetFolder = project.getFolder("src-gen");

		// At the end a new java file is created in the target folder.
		return createFile(targetFolder, name, derived, content);
	}

	/**
	 * Returns a folder with the same name as <code>newFolder</code> located in
	 * <code>newFolder</code>. The function create such folder if it is
	 * necessary.
	 * 
	 * @param container
	 *            The container folder.
	 * @param newFolder
	 *            The name of the folder needed.
	 * @return A folder in the <code>container</code> named
	 *         <code>newFolder</code>.
	 * @throws CoreException
	 *             If the folder can not be created.
	 */
	public static IFolder getOrCreateFolder(IFolder container, String newFolder)
			throws CoreException {
		// Referring a folder by a relative name.
		IFolder folder = container.getFolder(newFolder);

		// If the folder doesn't exists create it.
		if (!folder.exists()) {
			IProgressMonitor monitor = new NullProgressMonitor();
			folder.create(true, true, monitor);
		}

		// Return with the folder.
		return folder;
	}

	/**
	 * Creates a file named <code>name</code> into the folder
	 * <code>folder</code>with the content <code>content</code> and sets the
	 * derived. It overwrites only derived files and it doesn't delete anything
	 * editable by the user.
	 * 
	 * @param folder
	 *            The target folder.
	 * @param name
	 *            The name of the new file.
	 * @param derived
	 *            The derived property of the new file.
	 * @param content
	 *            The content of the new file.
	 * @return The new file.
	 * @throws CoreException
	 *             If an existing file can not be deleted, the new file can not
	 *             be created or the derived property can not be set.
	 */
	public static IFile createFile(IFolder folder, String name,
			boolean derived, CharSequence content) throws CoreException {
		// Referring a file by a relative name.
		IFile file = folder.getFile(name);

		// If the file existed before, and it is not editable, it should be
		// deleted
		IProgressMonitor monitor = new NullProgressMonitor();
		if (file.exists() && file.isDerived())
			file.delete(true, monitor);

		// Create the file if it is to exists.
		if (!file.exists()) {
			file.create(
					new ByteArrayInputStream(content.toString().getBytes()),
					true, monitor);

			// Setting the properties of the file.
			if (derived)
				file.setDerived(true, monitor);
		}

		// Return with the file.
		return file;
	}

	// public static IProject createProject(String name) throws CoreException {
	// // Referring a project in the workspace by it's name
	// IProject project = ResourcesPlugin.getWorkspace().getRoot()
	// .getProject(name);
	//
	// // If the project is not exist it will be created.
	// IProgressMonitor monitor = new NullProgressMonitor();
	// if (!project.exists())
	// project.create(monitor);
	//
	// // The project should be opened.
	// project.open(IResource.BACKGROUND_REFRESH, monitor);
	//
	// // Setting natures of the project
	// IProjectDescription desc = project.getDescription();
	// desc.setNatureIds(new String[] { "org.eclipse.jdt.core.javanature"
	// /* ,"org.eclipse.pde.PluginNature" */});
	// project.setDescription(desc, monitor);
	// return project;
	// }
}
