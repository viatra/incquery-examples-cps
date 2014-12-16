package org.eclipse.incquery.examples.cps.xform.m2t.jdt

import com.google.common.base.Preconditions
import com.google.common.base.Splitter
import java.util.HashMap
import java.util.logging.Logger
import org.eclipse.incquery.examples.cps.deployment.BehaviorState
import org.eclipse.incquery.examples.cps.deployment.BehaviorTransition
import org.eclipse.incquery.examples.cps.deployment.DeploymentApplication
import org.eclipse.incquery.examples.cps.deployment.DeploymentBehavior
import org.eclipse.incquery.examples.cps.deployment.DeploymentHost
import org.eclipse.incquery.examples.cps.deployment.common.WaitTransitionMatcher
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.exceptions.CPSGeneratorException
import org.eclipse.incquery.examples.cps.xform.m2t.distributed.utils.GeneratorHelper
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.jdt.core.dom.AST
import org.eclipse.jdt.core.dom.CompilationUnit
import org.eclipse.jdt.core.dom.Modifier.ModifierKeyword
import org.eclipse.jdt.core.dom.Name

class Generator {

	extension Logger logger = Logger.getLogger("cps.codegenerator")

	extension GeneratorHelper helper = new GeneratorHelper
	val String PROJECT_NAME
	val IncQueryEngine engine

	new(String projectName, IncQueryEngine engine) {
		PROJECT_NAME = projectName
		this.engine = engine
	}

	def generateHostCode(DeploymentHost host) throws CPSGeneratorException {
		val ast = AST.newAST(AST.JLS8)
		val cu = ast.newCompilationUnit

		ast.setPackage(cu, '''«PROJECT_NAME».hosts''')

		ast.addImport(cu, "org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application")
		ast.addImport(cu,
			"org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.communicationlayer.CommunicationNetwork")
		ast.addImport(cu, "org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.BaseHost")
		ast.addImport(cu, "com.google.common.collect.Lists")

		for (app : host.applications) {
			ast.addImport(cu, '''«PROJECT_NAME».applications.«app.id.purifyAndToUpperCamel»Application''')
		}

		val hostName = '''Host«host.ip.purifyAndToUpperCamel»'''
		val classDecl = ast.newPublicClass(hostName)
		classDecl.superclassType = ast.newSimpleType("BaseHost")

		val ctor = ast.newMethodDeclaration => [
			constructor = true
			modifiers() += ast.newModifier(ModifierKeyword.PUBLIC_KEYWORD)
			name = ast.newSimpleName(hostName)
			parameters += ast.newVariableDeclaration(false, "CommunicationNetwork", "network")
		]

		val ctorBody = ast.newBlock

		val superCall = ast.newSuperConstructorInvocation => [
			arguments += ast.newSimpleName("network")
		]
		ctorBody.statements += superCall

		val appList = ast.newAssignment => [
			leftHandSide = ast.newSimpleName("applications")
			rightHandSide = ast.newMethodInvocation => [
				expression = ast.newSimpleName("Lists")
				typeArguments += ast.newSimpleType("Application")
				name = ast.newSimpleName("newArrayList")
				for (app : host.applications) {
					arguments += ast.newClassInstanceCreation => [
						type = ast.newSimpleType('''«app.id.purifyAndToUpperCamel»Application''')
						arguments += ast.newThisExpression
					]
				}
			]
		]
		ctorBody.statements += ast.newExpressionStatement(appList)

		ctor.body = ctorBody

		classDecl.bodyDeclarations += ctor

		cu.types += classDecl
		cu.toString
	}

	def generateApplicationCode(DeploymentApplication application) throws CPSGeneratorException {
		val ast = AST.newAST(AST.JLS8)
		val cu = ast.newCompilationUnit

		val behavior = "Behavior" + application.id.purifyAndToUpperCamel
		val appClassName = application.id.purifyAndToUpperCamel + "Application"

		ast.setPackage(cu, '''«PROJECT_NAME».applications''')

		ast.addImport(cu,
			"org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.BaseApplication")
		ast.addImport(cu, "org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.hosts.Host")

		ast.addImport(cu, '''«PROJECT_NAME».hosts.statemachines.«behavior»''')

		val classDecl = ast.newPublicClass(appClassName)
		classDecl.superclassType = ast.newParameterizedType(ast.newSimpleType('''BaseApplication''')) => [
			typeArguments += ast.newSimpleType(behavior)
		]

		val idField = ast.newFieldDeclaration(
			ast.newVariableDeclarationFragment => [
				name = ast.newSimpleName("APP_ID")
				initializer = ast.newStringLiteral => [literalValue = application.id]
			]) => [
			it.type = ast.newSimpleType("String")
			modifiers() += #[
				ast.newModifier(ModifierKeyword.PROTECTED_KEYWORD),
				ast.newModifier(ModifierKeyword.STATIC_KEYWORD),
				ast.newModifier(ModifierKeyword.FINAL_KEYWORD)
			]
		]
		classDecl.bodyDeclarations += idField

		val ctor = ast.newMethodDeclaration => [
			constructor = true
			modifiers() += ast.newModifier(ModifierKeyword.PUBLIC_KEYWORD)
			name = ast.newSimpleName(appClassName)
			parameters += ast.newVariableDeclaration(false, "Host", "host")
		]

		val ctorBody = ast.newBlock

		val superCall = ast.newSuperConstructorInvocation => [
			arguments += ast.newSimpleName("host")
		]
		ctorBody.statements += superCall

		val currentState = ast.newAssignment => [
			leftHandSide = ast.newSimpleName("currentState")
			rightHandSide = ast.newQualifiedName(
				'''«behavior».«application.behavior.current.description.purifyAndToUpperCamel»''')
		]
		ctorBody.statements += ast.newExpressionStatement(currentState)

		ctor.body = ctorBody

		classDecl.bodyDeclarations += ctor

		val idGetter = ast.newMethodDeclaration => [
			modifiers() += #[
				ast.newMarkerAnnotation => [typeName = ast.newSimpleName("Override")],
				ast.newModifier(ModifierKeyword.PUBLIC_KEYWORD)
			]
			name = ast.newSimpleName("getAppID")
		]

		val getterBody = ast.newBlock => [
			statements += ast.newReturnStatement => [
				expression = ast.newSimpleName("APP_ID")
			]
		]
		idGetter.body = getterBody

		classDecl.bodyDeclarations += idGetter

		cu.types += classDecl
		cu.toString
	}

	def generateBehaviorCode(DeploymentBehavior behavior) throws CPSGeneratorException {
		val ast = AST.newAST(AST.JLS8)
		val cu = ast.newCompilationUnit

		val app = behavior.eContainer as DeploymentApplication
		val behaviorClassName = "Behavior" + app.id.purifyAndToUpperCamel

		ast.setPackage(cu, '''«PROJECT_NAME».hosts.statemachines''')

		ast.addImport(cu, "java.util.List")

		ast.addImport(cu, "org.apache.log4j.Logger")
		ast.addImport(cu, "org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.Application")
		ast.addImport(cu,
			"org.eclipse.incquery.examples.cps.m2t.proto.distributed.general.applications.statemachines.State")

		ast.addImport(cu, "com.google.common.collect.Lists")

		val enumDecl = ast.newEnumDeclaration => [
			name = ast.newSimpleName(behaviorClassName)
			superInterfaceTypes += #[
				ast.newParameterizedType(ast.newSimpleType("State")) => [
					typeArguments += ast.newSimpleType(behaviorClassName)
				]
			]
			for (state : behavior.states) {
				enumConstants += ast.generateState(state, behaviorClassName)
			}
		]

		cu.types += enumDecl
		cu.toString
	}

	def generateState(AST ast, BehaviorState state, String behaviorClassName) {
		val enumConst = ast.newEnumConstantDeclaration => [
			name = ast.newSimpleName(state.description.purifyAndToUpperCamel)
		]

		val possibleNextStatesMethodDecl = ast.newMethodDeclaration => [
			modifiers() += #[
				ast.newMarkerAnnotation => [typeName = ast.newSimpleName("Override")],
				ast.newModifier(ModifierKeyword.PUBLIC_KEYWORD)
			]
			name = ast.newSimpleName("possibleNextStates")
			parameters += ast.newVariableDeclaration(false, "Application", "app")
		]

		val possibleNextStatesBody = ast.newBlock => [
			statements += ast.newVariableDeclarationStatement(
				ast.newVariableDeclarationFragment => [
					name = ast.newSimpleName("possibleStates")
					initializer = ast.newMethodInvocation => [
						expression = ast.newSimpleName("Lists")
						name = ast.newSimpleName("newArrayList")
					]
				]) => [
				type = ast.newParameterizedType(ast.newSimpleType("List")) => [
					typeArguments += ast.newParameterizedType(ast.newSimpleType("State")) => [
						typeArguments += ast.newSimpleType(behaviorClassName)
					]
				]
			]
			for (trgState : state.calculateNeutralStateTransition) {
				statements += ast.newExpressionStatement(ast.newMethodInvocation => [
					expression = ast.newSimpleName("possibleStates")
					name = ast.newSimpleName("add")
					arguments += ast.newSimpleName(trgState.description.purifyAndToUpperCamel)
				])
			}
			for (transition : state.calculateSendStateTransition) {
				statements += ast.newExpressionStatement(ast.newMethodInvocation => [
					expression = ast.newSimpleName("possibleStates")
					name = ast.newSimpleName("add")
					arguments += ast.newSimpleName(transition.to.description.purifyAndToUpperCamel)
				])
			}
			val map = state.calculateWaitStateTransition
			for (trgTransition : map.keySet) {
				statements += ast.newIfStatement => [
					expression = ast.newMethodInvocation => [
						expression = ast.newSimpleName("app")
						name = ast.newSimpleName("hasMessageFor")
						arguments += ast.newSimpleName(trgTransition.description.purifyAndToUpperCamel)
					]
					thenStatement = ast.newExpressionStatement(
						ast.newMethodInvocation => [
							expression = ast.newSimpleName("possibleStates")
							name = ast.newSimpleName("add")
							arguments += ast.newSimpleName(map.get(trgTransition).description.purifyAndToUpperCamel)
						])
				]
			}
			statements += ast.newReturnStatement => [
				expression = ast.newSimpleName("possibleStates")
			]
		]
		possibleNextStatesMethodDecl.body = possibleNextStatesBody

		enumConst.anonymousClassDeclaration = ast.newAnonymousClassDeclaration => [
			bodyDeclarations += possibleNextStatesMethodDecl
		]
		enumConst
	}

	def calculateWaitStateTransition(BehaviorState srcState) {
		val waitTransitions = srcState.outgoing.filter [ transition |
			return transition.trigger.empty && transition.hasIncomingTrigger
		]
		val map = new HashMap<BehaviorTransition, BehaviorState>

		waitTransitions.forEach [ waitTrans |
			map.put(waitTrans, waitTrans.to)
		]

		return map
	}

	def calculateSendStateTransition(BehaviorState srcState) {
		srcState.outgoing.filter [ transition |
			return !transition.trigger.empty
		]
	}

	def calculateNeutralStateTransition(BehaviorState srcState) {
		srcState.outgoing.filter [ transition |
			return transition.trigger.empty && !transition.hasIncomingTrigger
		].map[transition|transition.to]
	}

	def getHasIncomingTrigger(BehaviorTransition transition) {
		WaitTransitionMatcher.on(engine).hasMatch(transition, null);
	}

	def setPackage(AST ast, CompilationUnit cu, String packageName) {
		val packageDeclaration = ast.newPackageDeclaration => [
			name = ast.newName(packageName)
		]
		cu.setPackage(packageDeclaration)
	}

	def addImport(AST ast, CompilationUnit cu, String importQualifiedName) {
		val importDecl = ast.newImportDeclaration => [
			name = ast.newName(importQualifiedName)
		]
		cu.imports.add(importDecl)
	}

	def newPublicClass(AST ast, String className) {
		val classDecl = ast.newTypeDeclaration => [
			interface = false
			name = ast.newSimpleName(className)
		]
		classDecl.modifiers() += ast.newModifier(ModifierKeyword.PUBLIC_KEYWORD)
		classDecl
	}

	def newVariableDeclaration(AST ast, boolean isArray, String type, String name) {
		ast.newSingleVariableDeclaration => [
			if (isArray) {
				it.type = ast.newArrayType(ast.newSimpleType(type))
			} else {
				it.type = ast.newSimpleType(type)
			}
			it.name = ast.newSimpleName(name)
		]
	}

	def newSimpleType(AST ast, String typeName) {
		Preconditions.checkArgument(!typeName.contains('.'),
			'''Cannot create type from type name >«typeName»< The name cannot be qualified.''')
		ast.newSimpleType(ast.newSimpleName(typeName))
	}

	def newQualifiedName(AST ast, String name) {
		Preconditions.checkArgument(name.contains('.'),
			'''Cannot create qualified name from name >«name»<. The name provided is not qualified.''')

		if (name.contains('.')) {
			var Name qName;
			val tokens = Splitter.on('.').split(name)
			val tokenIt = tokens.iterator

			qName = ast.newSimpleName(tokenIt.next)

			while (tokenIt.hasNext) {
				qName = ast.newQualifiedName(qName, ast.newSimpleName(tokenIt.next))
			}
			qName
		}
	}
}
