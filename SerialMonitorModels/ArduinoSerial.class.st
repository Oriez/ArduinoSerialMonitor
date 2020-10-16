Class {
	#name : #ArduinoSerial,
	#superclass : #Model,
	#instVars : [
		'pollTime',
		'myPort',
		'text',
		'baudRate',
		'myPortString',
		'error'
	],
	#category : #SerialMonitorModels
}

{ #category : #initialization }
ArduinoSerial class >> initializeWithArgs: portString baud: aBaudRate [
	|newObject|
	newObject := self new initialize: portString baud: aBaudRate.
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
      do: [ "error := true.
            self port close.
            self appendText: 'PRIMITIVE ERROR READING PORT !!'."
          ].
	^text
]

{ #category : #'as yet unclassified' }
ArduinoSerial >> initialize: portString baud: aBaudRate [
	myPortString := portString.
	baudRate := aBaudRate.
	SerialPort allInstances do: [:port| port close].

   
]

{ #category : #accessing }
ArduinoSerial >> port [
	| comPortNumber |
	SerialPort allInstances do: [ :port | port close ].
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
	myPortString := portString.
]
