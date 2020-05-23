Class {
	#name : #ArduinoSerialMapMorph,
	#superclass : #RubScrolledTextMorph,
	#instVars : [
		'error',
		'movingCamera'
	],
	#category : #SerialMonitor
}

{ #category : #initialization }
ArduinoSerialMapMorph class >> initialize: selectedPort [
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
		view signalUpdate ].
	view canvas camera translateTo: (map latLonToRoassal: coordinates).
	view canvas camera noInitializationWhenOpen.
	view canvas camera scale: 30.0.

	model := ArduinoSerialMap initializeWithPortAndmovingCamera: selectedPort movingCamera: movingCamera. 
	
	aMorph := self new initializeWithModel: model movingCamera: movingCamera.
	
	aMorph addMorph: view canvas buildMorph.


	^ aMorph
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph >> changePort: newPort [
	| tempModel |
	tempModel := ArduinoSerialMap initializeWithPortAndmovingCamera: newPort movingCamera: movingCamera.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph >> closePort [    self model close.
]

{ #category : #initialization }
ArduinoSerialMapMorph >> initializeWithModel: newModel movingCamera: aMovingCamera [
	movingCamera := aMovingCamera.
   self model: newModel.


]

{ #category : #display }
ArduinoSerialMapMorph >> openInWorld [
    | window |
    window := SystemWindow labelled: 'Serial Monitor'.
	 window addMorph: self frame: (0@0 corner: 1@1).
    window announcer
        when: WindowClosed
        send: #closePort
        to: self.
    window openInWorld.
]

{ #category : #'as yet unclassified' }
ArduinoSerialMapMorph >> step [
    self model announcer announce: RubTextUpdatedInModel
]

{ #category : #'model - stepping' }
ArduinoSerialMapMorph >> stepTime [
    ^1000
]
