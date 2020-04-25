Class {
	#name : #ArduinoSerialMap,
	#superclass : #Model,
	#instVars : [
		'pollTime',
		'myPort',
		'error',
		'text',
		'myPortString',
		'map',
		'view',
		'movingCamera'
	],
	#classVars : [
		'MyPortString'
	],
	#category : #SerialStuff
}

{ #category : #initialization }
ArduinoSerialMap class >> initializeWithPortAndmovingCamera: portString movingCamera: aMovingCamera [
	|newObject|
	newObject := self new initialize: portString movingCamera: aMovingCamera.
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
ArduinoSerialMap >> close [
    myPort close.
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> getText [
    | buffer nRead |
    buffer := String new: 1000.
    error ifNotNil: [^text].
	 myPort ifNil: [self port].
    [   nRead := myPort readInto: buffer startingAt: 1.
        nRead isZero
			ifFalse: [self appendText: (buffer copyFrom: 1 to: nRead)].
    ] on: PrimitiveFailed
      do: [ error := true.
            self port close.
            self appendText: 'PRIMITIVE ERROR READING PORT !!'.
          ].
	^text
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> initialize: portString [
	myPortString := portString.
	SerialPort allInstances do: [:port| port close].

   
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> initialize: portString movingCamera: aMovingCamera [
	myPortString := portString.
	movingCamera := aMovingCamera.
	SerialPort allInstances do: [:port| port close].

   
]

{ #category : #accessing }
ArduinoSerialMap >> port [
	| baudRate comPortNumber |
	SerialPort allInstances do: [ :port | port close ].
	baudRate := 9600.
	comPortNumber := myPortString.
	(myPort isNil or: [ myPort isClosed ])
		ifTrue: [ myPort := SerialPort new
				baudRate: baudRate;
				dataBits: 8;
				stopBitsType: 1;
				parityType: 0;
				yourself.
			(myPort openPort: comPortNumber) isNil
				ifFalse: [  ] ].
	^ myPort	"the return value"
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> returnText [
	^text
]

{ #category : #'as yet unclassified' }
ArduinoSerialMap >> setPort: portString [ 
	MyPortString := portString.
]
