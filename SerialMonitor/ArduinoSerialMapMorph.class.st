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
ArduinoSerialMapMorph class >> initializeWithModel: model [
	|newObject|
	newObject := self new initialize: model.
	^ newObject
]

{ #category : #initialization }
ArduinoSerialMapMorph class >> initializeWithModel: model movingCamera: movingCamera [
	|newObject|
	newObject := self new initialize: model movingCamera: movingCamera.
	^ newObject
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
ArduinoSerialMapMorph >> initialize [ | tempModel |
	super initialize.
	tempModel := ArduinoSerial initializeWithPort: '/dev/cu.wchusbserial1410'.
   self model: tempModel.


]

{ #category : #initialization }
ArduinoSerialMapMorph >> initialize: newModel [
	super initialize.
   self model: newModel.


]

{ #category : #initialization }
ArduinoSerialMapMorph >> initialize: newModel movingCamera: aMovingCamera. [
	super initialize.
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
