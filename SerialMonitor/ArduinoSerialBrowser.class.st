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
		'serialOptionsLabel'
	],
	#category : #SerialMonitor
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
	
	newRow: [ :row | row add: #displayObject ]
	origin: 0 @ 0.5 corner: 1 @ 1;
	
	yourself 
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> buildGraph [
	| points1 points2 ds graphView |
	points1 := #(1 1 4 6).
	points2 := #(2 4 2 10 5 2).

	graph := RTGrapher new.
	
	ds := RTData new.
	ds points: points1.
	ds connectColor: Color blue.
	ds y: #yourself.
	graph add: ds.
	
	ds := RTData new.
	ds points: points2.
	ds connectColor: Color green.
	ds y: #yourself.
	graph add: ds.

	graph axisX noLabel; noTick.
	graphDisplay := RubScrolledTextMorph new.
	graphView := graph build.
	graphDisplay addMorph: graphView canvas buildMorph.
	^graphDisplay 
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> buildMap [
	| map e coordinates view |
	view := RTView new
	   setCanvas: (TRCanvas new extent: 400 @ 300; yourself);
    	yourself.
	map := RTOSM new.
	e := map element.

	view add: e.

	coordinates := 32.1227355 @ 34.8066798.

	view @ RTDraggableView @ RTZoomableView.

	view canvas camera translateTo: (map latLonToRoassal: coordinates).
	view canvas camera noInitializationWhenOpen.
	view canvas camera scale: 30.0.
	RTEmptyViewContext setOnView: view.
	"mapDisplay := serialMorph new."
	"mapDisplay model: serialModel."
	serialMorph addMorph: view canvas buildMorph.

	^ mapDisplay.
	
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> buildMap: selectedPort [
	| map e coordinates view serialMapModel aMorph movingCamera |
	view := RTView new
	   setCanvas: (TRCanvas new extent: 400 @ 300; yourself);
    	yourself.
	map := RTOSM new.
	e := map element.

	view add: e.

	coordinates := 32.1227355 @ 34.8066798.

	view @ RTDraggableView @ RTZoomableView.
   movingCamera := [ :locationLatLong |
		view canvas camera translateTo: 
			(map latLonToRoassal: locationLatLong). 
		view signalUpdate ].
	view canvas camera translateTo: (map latLonToRoassal: coordinates).
	view canvas camera noInitializationWhenOpen.
	view canvas camera scale: 30.0.
	"RTEmptyViewContext setOnView: view."
	"mapDisplay := serialMorph new."
	"mapDisplay model: serialModel."
	serialMapModel := ArduinoSerialMap initializeWithPortAndmovingCamera: selectedPort movingCamera: 	movingCamera.
	aMorph := ArduinoSerialBasicMorph initializeWithModel: serialMapModel.
	aMorph addMorph: view canvas buildMorph.

	^ aMorph.
	
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

{ #category : #accessing }
ArduinoSerialBrowser >> graphDisplayAsSpec [
	^graphDisplayAsSpec
]

{ #category : #initialization }
ArduinoSerialBrowser >> initializePresenter [
	listOptions whenSelectedItemChanged: [ :text | self selectOption: text ]. 
	listPorts whenSelectedItemChanged: [ :text | self selectPort: text  ].
	
]

{ #category : #initialization }
ArduinoSerialBrowser >> initializeWidgets [
	"widget instantiation"
	| selectedPort |
	currentPlatform := OSPlatform current.
	selectedOptions := self buildMonitorOptionsList.
	serialOptionsLabel := self newLabel.
	serialOptionsLabel label: 'Monitor View Options'.
	
	selectedPort := self buildPortList.
	portListLabel := self newLabel.
	portListLabel label: 'Port List'.
	
	"
	serialModel := ArduinoSerial initializeWithPort: selectedPort.
	serialMorph := ArduinoSerialBasicMorph initializeWithModel: serialModel."
	
	
	mapDisplay := self buildMap: selectedPort.
	mapDisplayAsSpec := mapDisplay extent:400@300; asSpecAdapter.
	serialMorphAsSpec := mapDisplay extent:400@300; asSpecAdapter.
	graphDisplay := self buildGraph.
	graphDisplayAsSpec := graphDisplay extent:400@300; asSpecAdapter.
	
	displayObject := self graphDisplayAsSpec.
	"specification of order of focus"
	self focusOrder
	add: listOptions;
	add: listPorts;
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

{ #category : #accessing }
ArduinoSerialBrowser >> mapDisplayAsSpec [
	^mapDisplayAsSpec
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> portListLabel [
	^portListLabel
]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> selectOption: text [
	| selected |
	text = 'Basic' ifTrue: [ displayObject := self serialMorphAsSpec. selected:= 1 ].
	text = 'Map' ifTrue: [ displayObject := self mapDisplayAsSpec. selected:= 2].
	text = 'Graph' ifTrue: [ displayObject := self graphDisplayAsSpec. selected:= 3].
	text ifNotNil: [ 
	self needRebuild: false.
	self buildWithSpecLayout: self defaultSpec.
	self listOptions setSelectedIndex: selected.
	].

]

{ #category : #'as yet unclassified' }
ArduinoSerialBrowser >> selectPort: selectedPort [
	serialMorph changePort: selectedPort.
]

{ #category : #accessing }
ArduinoSerialBrowser >> serialMorphAsSpec [
	^serialMorphAsSpec
]

{ #category : #accessing }
ArduinoSerialBrowser >> serialOptionsLabel [
	^serialOptionsLabel
]

{ #category : #api }
ArduinoSerialBrowser >> title [
	^ 'Serial Monitor'
]
