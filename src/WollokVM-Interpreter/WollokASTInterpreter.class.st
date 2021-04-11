Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'bindings',
		'nativeMethods'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #executing }
WollokASTInterpreter >> activateMethod: aMessage of: aWollokVMObject withArguments: arguments [
	| method |
	method := self lookup: aMessage inObject: aWollokVMObject.
	
	method isNative ifTrue: [ ^ self performNativeMethod: method inObject: aWollokVMObject withArguments: arguments ].
	
	self shouldBeImplemented.
]

{ #category : #bindings }
WollokASTInterpreter >> addBinding: aName value: aWollokVMClass [ 
	
	bindings at: aName put: aWollokVMClass
]

{ #category : #bindings }
WollokASTInterpreter >> addBindingOfClass: aName fromString: aString [

	WollokReducedLoader new addBindingOfClass: aName fromString: aString in: self
]

{ #category : #interpreting }
WollokASTInterpreter >> initialize [

	super initialize.

	bindings := Dictionary new.
	
	WollokReducedLoader new loadInto: self
]

{ #category : #interpreting }
WollokASTInterpreter >> interpretProgram: aFileNode [ 

	| lastValue |

	aFileNode main elements do: [ :e | lastValue := e acceptVisitor: self ].

	^ lastValue	
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> isFalse: aBoolean [
	self flag: #todo. "Should receive a Wollok Boolean instead of a Pharo's"
	^ aBoolean not
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> lookup: aMessage inObject: aWollokVMObject [
	self flag: #todo. "Missing: anonymous objects, inheritance"
	^ aWollokVMObject wollokClass methodNamed: aMessage
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> performNativeMethod: aWollokMethodDeclarationNode inObject: aWollokVMObject withArguments: arguments [
	^ aWollokVMObject wollokClass performNativeMethod: aWollokMethodDeclarationNode inObject: aWollokVMObject withArguments: arguments
]

{ #category : #bindings }
WollokASTInterpreter >> resolve: aString [ 
	
	^ bindings at: aString
]

{ #category : #visiting }
WollokASTInterpreter >> visitBinaryOperation: aWollokBinaryOperationNode [
	| leftOperand rightOperand operation |
	leftOperand := aWollokBinaryOperationNode leftOperand acceptVisitor: self.
	rightOperand := aWollokBinaryOperationNode rightOperand acceptVisitor: self.
	operation := aWollokBinaryOperationNode operation value.
	
	^ self activateMethod: operation of: leftOperand withArguments: (Array braceWith: rightOperand)
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		yourself
]
