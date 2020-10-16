Class {
	#name : #ArduinoSerialGraph,
	#superclass : #ArduinoSerial,
	#instVars : [
		'graphData',
		'points',
		'updateGraph'
	],
	#classVars : [
		'MyPortString'
	],
	#category : #SerialMonitorModels
}

{ #category : #initialization }
ArduinoSerialGraph class >> initializeWithPortAndGraphData: portString updateGraph: aUpdateGraph baud: aBaudRate [
	|newObject|
	newObject := self new initialize: portString updateGraph: aUpdateGraph baud: aBaudRate.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> appendText: aString [
   | number is_match |
	text ifNil: [text := ''].
   text ifNotNil: [ 
		aString splitOn: Character cr do: [ 
			:each |
			is_match := each asString matchesRegex: '[0-9\-]*'.
			is_match ifTrue: [  
			number := each asNumber.
			"number := 200 atRandom - 100."
		   updateGraph value: number.
			 ]
		]
	 ]. 
	text := text , aString.
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> initialize: portString updateGraph: aUpdateGraph baud: aBaudRate [
	myPortString := portString.
	updateGraph := aUpdateGraph.
	points := OrderedCollection new.
	baudRate := aBaudRate.
	SerialPort allInstances do: [:port| port close].

   
]
