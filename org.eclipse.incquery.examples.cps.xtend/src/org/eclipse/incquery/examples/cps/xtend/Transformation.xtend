package org.eclipse.incquery.examples.cps.xtend

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.xtend2.lib.StringConcatenation

class Transformation {
	
	def doGenerate(Resource input) {
		var engine = IncQueryEngine.on(input)
		AllocationMatcher.on(engine).allMatches.forEach[ 
			GeneratorHelper::createJavaFile(input, it.app.id.replace(" ", "") + "To" + it.host.id.replace(" ", "") + ".json", true, generateCommands(it))
		]		
	}
	
	def generateCommands(AllocationMatch match) {
		var concat = StringConcatenation.newInstance;
		concat.append(generateInstallCommand(match))
		concat.append(generateStartCommand(match))
		concat		
	}
	
	def generateInstallCommand(AllocationMatch match) '''
	{
		"InstallCommand" : {
				"nodeIp" : "«match.host.nodeIp»",
				"appName" : "«match.app.id»".
				"zipFileUrl" : "«match.app.type.zipFileUrl»"
			}
	}
	'''
	
	def generateStartCommand(AllocationMatch match) '''
	{
		"StartCommand" : {
				"nodeIp" : "«match.host.nodeIp»",
				"appName" : "«match.app.id»".
				"exeFileLocation" : "«match.app.type.exeFileLocation»",
				"exeType" : "«match.app.type.exeType»",
				"dbUrl" : "«match.app.type.cps.dbUrl»",
				"dbUser" : "«match.app.dbUser»",
				"dbPassword" : "«match.app.dbPassword»"
			}
	}
	'''
}