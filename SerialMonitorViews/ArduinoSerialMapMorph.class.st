Class {
	#name : #ArduinoSerialMapMorph,
	#superclass : #ArduinoSerialBasicMorph,
	#instVars : [
		'error',
		'movingCamera'
	],
	#category : #SerialMonitorViews
}

{ #category : #initialization }
ArduinoSerialMapMorph class >> initialize: selectedPort baud: aBaudRate [
	|map e coordinates view aMorph movingCamera model |

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
		e := (RTEllipse new
			  size: 0.3;
			  color: (Color blue alpha: 1)) elementOn: 2.
			e @ RTPopup @ RTHighlightable.
			e translateTo: (map latLonToRoassal: locationLatLong).
		view add: e.
		view signalUpdate ].
	view canvas camera translateTo: (map latLonToRoassal: coordinates).
	view canvas camera noInitializationWhenOpen.
	view canvas camera scale: 30.0.

	model := ArduinoSerialMap initializeWithPortAndmovingCamera: selectedPort movingCamera: movingCamera baud: aBaudRate. 
	
	aMorph := self new initializeWithModel: model movingCamera: movingCamera.
	
	aMorph addMorph: view canvas buildMorph.


	^ aMorph
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph >> changeBaudRate: newBaudRate [
	| tempModel currentPort |
	currentPort := self getSelectedPort.
	tempModel := ArduinoSerialMap initializeWithPortAndmovingCamera: currentPort movingCamera: movingCamera baud: newBaudRate.
	self setSelectedBaud: newBaudRate.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph >> changePort: newPort [
	| tempModel currentBaud |
	currentBaud := self getSelectedBaud.
	tempModel := ArduinoSerialMap initializeWithPortAndmovingCamera: newPort movingCamera: movingCamera baud: currentBaud.
	self setSelectedPort: newPort.
   self model: tempModel.
]

{ #category : #initialization }
ArduinoSerialMapMorph >> initialize [
	| tempModel |
	super initialize.
	tempModel := ArduinoSerialMap initializeWithPortAndmovingCamera: '/dev/cu.wchusbserial1410' movingCamera: movingCamera baud: 9600.
   self model: tempModel.
]

{ #category : #initialization }
ArduinoSerialMapMorph >> initializeWithModel: newModel movingCamera: aMovingCamera [
	
	movingCamera := aMovingCamera.
   self model: newModel.


]

{ #category : #'model - stepping' }
ArduinoSerialMapMorph >> stepTime [
    ^1000
]
