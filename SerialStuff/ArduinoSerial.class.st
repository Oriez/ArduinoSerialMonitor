Class {
	#name : #ArduinoSerial,
	#superclass : #Model,
	#instVars : [
		'pollTime',
		'myPort',
		'error',
		'text',
		'myPortString'
	],
	#classVars : [
		'MyPortString'
	],
	#category : #SerialStuff
}

{ #category : #initialization }
ArduinoSerial class >> initializeWithPort: portString [
	|newObject|
	newObject := self new initialize: portString.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerial >> appendText: aString [
    text ifNil: [text := ''].
    text := text , aString.
]

{ #category : #'as yet unclassified' }
ArduinoSerial >> close [
    myPort close.
]

{ #category : #'as yet unclassified' }
ArduinoSerial >> getText [
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
ArduinoSerial >> initialize: portString [
	myPortString := portString.
	SerialPort allInstances do: [:port| port close].

   
]

{ #category : #accessing }
ArduinoSerial >> port [
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
ArduinoSerial >> returnText [
	^text
]

{ #category : #'as yet unclassified' }
ArduinoSerial >> setPort: portString [ 
	MyPortString := portString.
]
