Class {
	#name : #ArduinoSerialMap,
	#superclass : #ArduinoSerial,
	#instVars : [
		'map',
		'view',
		'movingCamera'
	],
	#classVars : [
		'MyPortString'
	],
	#category : #SerialMonitorModels
}

{ #category : #initialization }
ArduinoSerialMap class >> initializeWithPortAndmovingCamera: portString movingCamera: movingCamera baud: aBaudRate [
	|newObject|
	newObject := self new initialize: portString movingCamera: movingCamera baud: aBaudRate.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> appendText: aString [
   | splitted lat lon |
	text ifNil: [text := ''].
    
	splitted := aString splitOn: '@'.
	splitted size > 1 ifTrue: [
	lat:= splitted at: 1 asNumber.
	lon:= splitted at: 2 asNumber.
	movingCamera value: lat asNumber @ lon asNumber.
	].
	
	text := text , aString.
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> initialize: portString movingCamera: aMovingCamera baud: aBaudRate [
	myPortString := portString.
	movingCamera := aMovingCamera.
	baudRate := aBaudRate.
	SerialPort allInstances do: [:port| port close].

   
]
