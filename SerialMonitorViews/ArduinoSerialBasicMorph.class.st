Class {
	#name : #ArduinoSerialBasicMorph,
	#superclass : #RubScrolledTextMorph,
	#instVars : [
		'error',
		'selectedPort',
		'selectedBaud'
	],
	#category : #SerialMonitorViews
}

{ #category : #initialization }
ArduinoSerialBasicMorph class >> initialize: selectedPort baud: selectedBaud [
	|newObject model |
	model := ArduinoSerial initializeWithArgs: selectedPort baud: selectedBaud.
	newObject := self new initialize: model.
	^ newObject
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> changeBaudRate: aBaudRate [
	| tempModel |
	self setSelectedBaud: aBaudRate.
	tempModel := ArduinoSerial initializeWithArgs: selectedPort baud: aBaudRate.
	self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> changePort: newPort [
	| tempModel |
	tempModel := ArduinoSerial initializeWithArgs: newPort baud: selectedBaud.
	self setSelectedPort: newPort.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> closePort [    self model close.
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> getSelectedBaud [
	^selectedBaud 
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> getSelectedPort [
	^selectedPort 
]

{ #category : #initialization }
ArduinoSerialBasicMorph >> initialize [ | tempModel |
	super initialize.
	tempModel := ArduinoSerial initializeWithArgs: '/dev/cu.wchusbserial1410' baud: 9600.
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

{ #category : #initialization }
ArduinoSerialBasicMorph >> setSelectedBaud: baud [
	selectedBaud := baud
	
]

{ #category : #initialization }
ArduinoSerialBasicMorph >> setSelectedPort: port [
	selectedPort := port
]

{ #category : #'as yet unclassified' }
ArduinoSerialBasicMorph >> step [
    self model announcer announce: RubTextUpdatedInModel
]

{ #category : #'model - stepping' }
ArduinoSerialBasicMorph >> stepTime [
    ^100
]
