Class {
	#name : #ArduinoSerialBasicMorph,
	#superclass : #RubScrolledTextMorph,
	#instVars : [
		'error'
	],
	#category : #SerialMonitor
}

{ #category : #initialization }
ArduinoSerialBasicMorph class >> initialize: selectedPort [
	|newObject model |
	model := ArduinoSerial initializeWithPort: selectedPort.
	newObject := self new initialize: model.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> changePort: newPort [
	| tempModel |
	tempModel := ArduinoSerial initializeWithPort: newPort.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> closePort [    self model close.
]

{ #category : #initialization }
ArduinoSerialBasicMorph >> initialize [ | tempModel |
	super initialize.
	tempModel := ArduinoSerial initializeWithPort: '/dev/cu.wchusbserial1410'.
   self model: tempModel.


]

{ #category : #initialization }
ArduinoSerialBasicMorph >> initialize: newModel [
	super initialize.
   self model: newModel.


]

{ #category : #display }
ArduinoSerialBasicMorph >> openInWorld [
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
ArduinoSerialBasicMorph >> step [
    self model announcer announce: RubTextUpdatedInModel
]

{ #category : #'model - stepping' }
ArduinoSerialBasicMorph >> stepTime [
    ^1000
]
