# VIATRA CPS Demonstrator

[![Build Status](https://build.inf.mit.bme.hu/jenkins/job/CPS-Demonstrator/badge/icon)](https://build.inf.mit.bme.hu/jenkins/job/CPS-Demonstrator/)

A comprehensive example showing off VIATRA features on a Cyber Physical System modeling domain.
Includes:
  * live validation
  * query-based viewers
  * query-driven derived features
  * model transformations
  * code generators

## Getting started

You can use [Oomph](https://www.eclipse.org/oomph) to deploy a ready to go Eclipse IDE with the projects imported and all required dependencies already installed.

Start the [Oomph installer](https://wiki.eclipse.org/Eclipse_Oomph_Installer), select the Eclipse product and the product version. Use the **Add a project to the user project of the selected catalog** option to provide the setup file with the following URL: `https://raw.githubusercontent.com/IncQueryLabs/incquery-examples-cps/master/releng/org.eclipse.viatra.examples.cps.setup/CPSExample.setup`
  * The Git password is only required for [Mylyn integration](http://eclipse.github.io/) to see tasks and pull requests, if you don't want that, just enter a whitespace.
  * For the repository URI, select Git only if you have a public key added to GitHub and the private key set up correctly.

Read the [Oomph help](http://download.eclipse.org/oomph/help/org.eclipse.oomph.setup.doc/html/user/wizard/index.html) if you are lost in the wizard's forest.

## Additional details

Go read the [wiki](https://github.com/IncQueryLabs/incquery-examples-cps/wiki)!
