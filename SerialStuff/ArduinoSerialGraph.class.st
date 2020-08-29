Class {
	#name : #ArduinoSerialGraph,
	#superclass : #Model,
	#instVars : [
		'pollTime',
		'myPort',
		'error',
		'text',
		'myPortString',
		'map',
		'view',
		'movingCamera',
		'baudRate',
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
		number := aString asNumber.
		points add: number.
		updateGraph value: points.
	 ]. text , aString.
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> close [
    myPort close.
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> getText [
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
ArduinoSerialGraph >> initialize: portString updateGraph: aUpdateGraph baud: aBaudRate [
	myPortString := portString.
	updateGraph := aUpdateGraph.
	points := OrderedCollection new.
	baudRate := aBaudRate.
	SerialPort allInstances do: [:port| port close].

   
]

{ #category : #accessing }
ArduinoSerialGraph >> port [
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
ArduinoSerialGraph >> returnText [
	^text
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraph >> setPort: portString [ 
	MyPortString := portString.
]
