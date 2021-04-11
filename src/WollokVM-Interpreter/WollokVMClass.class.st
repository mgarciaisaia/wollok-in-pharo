Class {
	#name : #WollokVMClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'ast',
		'nativeMethods'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #accessing }
WollokVMClass >> allVariables [

	self flag: #todo.
	^ #()
]

{ #category : #accessing }
WollokVMClass >> ast [
	^ ast
]

{ #category : #accessing }
WollokVMClass >> ast: anObject [
	ast := anObject
]

{ #category : #'as yet unclassified' }
WollokVMClass >> methodNamed: aMessage [
	^ self methods detect: [ :method | method name value = aMessage ] ifNone: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
WollokVMClass >> methods [
	^ ast methods
]

{ #category : #accessing }
WollokVMClass >> name [
	^ name
]

{ #category : #accessing }
WollokVMClass >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WollokVMClass >> nativeMethods [
	^ nativeMethods ifNil: [ nativeMethods := IdentityDictionary new ]
]

{ #category : #'as yet unclassified' }
WollokVMClass >> nativeMethods: aDictionary [ 
	nativeMethods := aDictionary 
]

{ #category : #'as yet unclassified' }
WollokVMClass >> performNativeMethod: aWollokMethodDeclarationNode inObject: aWollokVMObject withArguments: arguments [
	^ (self nativeMethods at: aWollokMethodDeclarationNode name value) value: aWollokVMObject value: arguments 

]

{ #category : #printing }
WollokVMClass >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		space;
		nextPut: $(;
		print: name;
		nextPut: $)
		 
]
