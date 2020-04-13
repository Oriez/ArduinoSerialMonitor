Class {
	#name : #ArduinoSerialMorph,
	#superclass : #RubScrolledTextMorph,
	#instVars : [
		'error'
	],
	#category : #SerialMonitor
}

{ #category : #initialization }
ArduinoSerialMorph class >> initializeWithModel: model [
	|newObject|
	newObject := self new initialize: model.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerialMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialMorph >> changePort: newPort [
	| tempModel |
	tempModel := ArduinoSerial initializeWithPort: newPort.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialMorph >> closePort [    self model close.
]

{ #category : #initialization }
ArduinoSerialMorph >> initialize [ | tempModel |
	super initialize.
	tempModel := ArduinoSerial initializeWithPort: '/dev/cu.wchusbserial1410'.
   self model: tempModel.


]

{ #category : #initialization }
ArduinoSerialMorph >> initialize: newModel [
	super initialize.
   self model: newModel.


]

{ #category : #display }
ArduinoSerialMorph >> openInWorld [
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
ArduinoSerialMorph >> step [
    self model announcer announce: RubTextUpdatedInModel
]

{ #category : #'model - stepping' }
ArduinoSerialMorph >> stepTime [
    ^1000
]
