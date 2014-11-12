package org.eclipse.incquery.examples.cps.view;

import java.util.Collection;

import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.gef4.layout.LayoutAlgorithm;
import org.eclipse.gef4.layout.algorithms.SpaceTreeLayoutAlgorithm;
import org.eclipse.gef4.zest.core.viewers.GraphViewer;
import org.eclipse.incquery.examples.cps.cyberPhysicalSystem.presentation.CyberPhysicalSystemEditor;
import org.eclipse.incquery.runtime.api.IQuerySpecification;
import org.eclipse.incquery.runtime.api.IncQueryEngine;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.incquery.viewers.runtime.model.Containment;
import org.eclipse.incquery.viewers.runtime.model.Edge;
import org.eclipse.incquery.viewers.runtime.model.IncQueryViewerDataModel;
import org.eclipse.incquery.viewers.runtime.model.Item;
import org.eclipse.incquery.viewers.runtime.model.ViewerDataFilter;
import org.eclipse.incquery.viewers.runtime.model.ViewerState;
import org.eclipse.incquery.viewers.runtime.model.ViewerState.ViewerStateFeature;
import org.eclipse.incquery.viewers.runtime.model.listeners.IViewerStateListener;
import org.eclipse.incquery.viewers.runtime.zest.IncQueryGraphViewers;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.IPartListener2;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchPartReference;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.part.ViewPart;

import com.google.common.collect.ImmutableSet;


public abstract class AbstractCpsViewPart extends ViewPart implements IPartListener2 {

		private GraphViewer viewer;
		private IncQueryEngine engine = null;
		protected IEditorPart activeEditor;
		
		public AbstractCpsViewPart() {
			IWorkbenchPage workbenchPage = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage();
			workbenchPage.addPartListener(this);	
		}

		protected IncQueryEngine getEngine() {
			return engine;
		}
		
		protected abstract Collection<IQuerySpecification<?>> getSpecifications() throws IncQueryException;
		
		@Override
		public void createPartControl(Composite parent) {
			viewer = new GraphViewer(parent, SWT.None);
		}

		@Override
		public void setFocus() {
			viewer.getControl().setFocus();
		}
		
		protected void engineUpdated() {
			try {
				ViewerState state = IncQueryViewerDataModel.newViewerState(getEngine(), getSpecifications(), ViewerDataFilter.UNFILTERED,
						ImmutableSet.of(ViewerStateFeature.EDGE, ViewerStateFeature.CONTAINMENT));
				IncQueryGraphViewers.bindWithIsolatedNodes(viewer, state, true);
				viewer.setLayoutAlgorithm(getLayout());
				viewer.applyLayout();
				state.addStateListener(new IViewerStateListener() {
					
					@Override
					public void itemDisappeared(Item item) {
						viewer.applyLayout();
					}
					
					@Override
					public void itemAppeared(Item item) {
						viewer.applyLayout();
					}
					
					@Override
					public void edgeDisappeared(Edge edge) {
						viewer.applyLayout();
					}
					
					@Override
					public void edgeAppeared(Edge edge) {
						viewer.applyLayout();
					}
					
					@Override
					public void containmentDisappeared(Containment containment) {
						viewer.applyLayout();
					}
					
					@Override
					public void containmentAppeared(Containment containment) {
						viewer.applyLayout();
					}
				});
			} catch (IncQueryException e) {
				e.printStackTrace();
			}
		}

		protected LayoutAlgorithm getLayout() {
			return new SpaceTreeLayoutAlgorithm();
		}
		
		@Override
		public void partActivated(IWorkbenchPartReference partRef) {
			activeEditor = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().getActiveEditor();
			if (activeEditor instanceof CyberPhysicalSystemEditor) {
				CyberPhysicalSystemEditor edp = (CyberPhysicalSystemEditor) activeEditor;
				ResourceSet resourceSet = edp.getEditingDomain().getResourceSet();
				
				if(engine != null && resourceSet == engine.getScope())
					return;
				
	            try {
					engine = IncQueryEngine.on(resourceSet);
				} catch (IncQueryException e) {
					e.printStackTrace();
				} 
	            
	            engineUpdated();            
	        }
		}

		@Override
		public void partBroughtToTop(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void partClosed(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void partDeactivated(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void partOpened(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void partHidden(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void partVisible(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void partInputChanged(IWorkbenchPartReference partRef) {
			// TODO Auto-generated method stub
			
		}	
}
