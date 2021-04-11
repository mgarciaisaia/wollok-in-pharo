Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'bindings'
	],
	#category : #'WollokVM-Interpreter'
}

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

{ #category : #executing }
WollokASTInterpreter >> lookup: aMessage on: aWollokVMClass [
	^(aWollokVMClass methodNamed: aMessage) ifNil: [ ^ aWollokVMClass wollokSuperclass methodNamed: aMessage].
]

{ #category : #bindings }
WollokASTInterpreter >> resolve: aString [ 
	
	^ bindings at: aString
]

{ #category : #visiting }
WollokASTInterpreter >> visitBinaryOperation: aWollokBinaryOperationNode [
	| left right operation |
	left := aWollokBinaryOperationNode leftOperand acceptVisitor: self.
	right := aWollokBinaryOperationNode rightOperand acceptVisitor: self.
	operation := aWollokBinaryOperationNode operation value.
	^ self wollokObject: left receive: operation withArguments: #( right ).
]

{ #category : #visiting }
WollokASTInterpreter >> visitBooleanLiteral: aWollokBooleanLiteralNode [

	^ self wollokBooleanFrom: aWollokBooleanLiteralNode booleanValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #literals }
WollokASTInterpreter >> wollokBooleanFrom: aBoolean [ 
	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Boolean');
		literalValue: aBoolean;
		yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		yourself
]

{ #category : #executing }
WollokASTInterpreter >> wollokObject: aWollokVMObject receive: aMessage withArguments: arguments [
	| method |
	method := self lookup: aMessage on: aWollokVMObject wollokClass.
	
	method isNative ifTrue: [ ^ self shouldBeImplemented ].

	self shouldBeImplemented.
]
