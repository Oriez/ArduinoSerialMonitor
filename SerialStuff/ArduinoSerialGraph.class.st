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
	#category : #SerialStuff
}

{ #category : #initialization }
ArduinoSerialGraph class >> initializeWithPortAndGraphData: portString updateGraph: updateGraph baud: aBaudRate [
	|newObject|
	newObject := self new initialize: portString updateGraph: updateGraph baud: aBaudRate.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> appendText: aString [
   | number |
	text ifNil: [text := ''].
   text ifNotNil: [ 
		aString isAllDigits ifTrue: [  
			number := aString asNumber.
		   points add: number.
		   updateGraph value: points.
		]
	 ]. text , aString.
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> initialize: portString updateGraph: aUpdateGraph baud: aBaudRate [
	myPortString := portString.
	updateGraph := aUpdateGraph.
	points := OrderedCollection new.
	baudRate := aBaudRate.
	SerialPort allInstances do: [:port| port close].

   
]
