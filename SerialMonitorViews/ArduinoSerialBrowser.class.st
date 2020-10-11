Class {
	#name : #ArduinoSerialBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'listPorts',
		'serialMorph',
		'serialMorphAsSpec',
		'monitorOptions',
		'listOptions',
		'selectedOptions',
		'mapDisplay',
		'mapDisplayAsSpec',
		'displayObject',
		'serialModel',
		'graph',
		'graphDisplay',
		'graphDisplayAsSpec',
		'currentPlatform',
		'portListLabel',
		'serialOptionsLabel',
		'selectedPort',
		'displayedMorph',
		'baudDropList',
		'baudRateLabel',
		'selectedBaud'
	],
	#category : #SerialMonitorViews
}

{ #category : #specs }
ArduinoSerialBrowser class >> defaultSpec [
	^ SpecLayout composed
	newRow: [ :row |
		row add: #portListLabel; add: #serialOptionsLabel]
	origin: 0 @ 0 corner: 1 @ 0.05;
	
	newRow: [ :row |
		row add: #listPorts; add: #listOptions]
	origin: 0 @ 0.05 corner: 1 @ 0.5;
	
	newRow: [ :row |
		row add: #baudRateLabel; add: #baudDropList]
	origin: 0.15 @ 0.5 corner: 0.5 @ 0.55;
	
	newRow: [ :row | row add: #displayObject ]
	origin: 0 @ 0.55 corner: 1 @ 1;
	
	yourself 
]

{ #category : #accessing }
ArduinoSerialBrowser >> baudDropList [
	^baudDropList 
]

{ #category : #accessing }
ArduinoSerialBrowser >> baudRateLabel [
	^baudRateLabel
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> buildBaudList [
	baudDropList := self newDropList items: #(300 1200 2400 4800 9600 19200 38400 57600 74880 115200 230400 250000 500000 1000000).
	
	^9600
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> buildMonitorOptionsList [
	listOptions := self newList.

	listOptions items: (Array withAll: #('Basic' 'Map' 'Graph')).
	
	^ listOptions listElementAt: 1
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> buildPortList [
	| command portsArray exitStatus |
	listPorts := self newList.
	currentPlatform isWindows ifTrue: [ 
	command := OSProcess waitForCommand: 'cscript.exe //nologo listComPorts.vbs'.
	exitStatus := command exitStatus.
	exitStatus = 0 ifTrue: [ 
			portsArray:= 'comPorts.txt' asFileReference readStreamDo: [ :in |
  			Array streamContents: [ :out |
    		[ in atEnd ] whileFalse: [ out nextPut: in nextLine ] ] ].

			listPorts items: (Array withAll: portsArray).
		 ].
	].
	currentPlatform isMacOS ifTrue: [ 
		| workingDir test |
		workingDir := '/dev' asFileReference.
		portsArray:= workingDir children select: [ :each | 
			each basename beginsWith: 'cu.usbserial'
			].
		test:= portsArray collect: [ :item | item pathString ].
		listPorts items: (Array withAll: test).
	].
	
	^listPorts
]

{ #category : #accessing }
ArduinoSerialBrowser >> displayObject [
	^displayObject
]

{ #category : #api }
ArduinoSerialBrowser >> extent [
	^ 600@700
]

{ #category : #initialization }
ArduinoSerialBrowser >> initializePresenter [
	listOptions whenSelectedItemChanged: [ :text | self selectOption: text ]. 
	listPorts whenSelectedItemChanged: [ :text | self selectPort: text  ].
   baudDropList whenSelectedItemChanged: [:text | self selectBaud: text  ].
	
]

{ #category : #initialization }
ArduinoSerialBrowser >> initializeWidgets [
	"widget instantiation"
	currentPlatform := OSPlatform current.
	selectedOptions := self buildMonitorOptionsList.
	
	selectedBaud := self buildBaudList. 
	baudRateLabel := self newLabel.
	baudRateLabel label: 'Baud rate: '.
	
	serialOptionsLabel := self newLabel.
	serialOptionsLabel label: 'Monitor View Options'.
	selectedPort := self buildPortList.
	
	portListLabel := self newLabel.
	portListLabel label: 'Port List'.
	
	displayedMorph := ArduinoSerialBasicMorph initialize: selectedPort baud: selectedBaud.
	displayObject := displayedMorph extent:400@300; asSpecAdapter.
	
	"specification of order of focus"
	self focusOrder
	add: listOptions;
	add: listPorts;
	add: baudDropList;
	add: portListLabel
]

{ #category : #accessing }
ArduinoSerialBrowser >> listOptions [
	^ listOptions
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> listPorts [
	^ listPorts
]

{ #category : #accessing }
ArduinoSerialBrowser >> mapDisplay [
	^mapDisplay 
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> portListLabel [
	^portListLabel
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> selectBaud: aSelectedBaud [
	selectedBaud := aSelectedBaud.
	displayedMorph changeBaudRate: aSelectedBaud.
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> selectOption: text [
	| selected |
	text = 'Basic' ifTrue: [ 
		displayedMorph := ArduinoSerialBasicMorph initialize: selectedPort baud: selectedBaud. 
		selected:= 1
		].
	text = 'Map' ifTrue: [ 
		displayedMorph := ArduinoSerialMapMorph initialize: selectedPort baud: selectedBaud.
		selected:= 2
		].
	text = 'Graph' ifTrue: [ 
		displayedMorph := ArduinoSerialGraphMorph initialize: selectedPort baud: selectedBaud.
		selected:= 3
		].
	text ifNotNil: [ 
	displayObject := displayedMorph extent:400@300; asSpecAdapter.
	self needRebuild: false.
	self buildWithSpecLayout: self defaultSpec.
	self listOptions setSelectedIndex: selected.
	].

]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> selectPort: aSelectedPort [
	selectedPort := aSelectedPort.
	displayedMorph changePort: aSelectedPort.

]

{ #category : #accessing }
ArduinoSerialBrowser >> serialOptionsLabel [
	^serialOptionsLabel
]

{ #category : #api }
ArduinoSerialBrowser >> title [
	^ 'Serial Monitor'
]
