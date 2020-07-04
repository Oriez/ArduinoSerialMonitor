Class {
	#name : #ArduinoSerialGraphMorph,
	#superclass : #RubScrolledTextMorph,
	#instVars : [
		'error',
		'movingCamera'
	],
	#category : #SerialMonitor
}

{ #category : #initialization }
ArduinoSerialGraphMorph class >> initialize: selectedPort [
	| points1 points2 ds graphView model aMorph graph |
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
	aMorph  := RubScrolledTextMorph new.
	graphView := graph build.

	model := ArduinoSerial initializeWithPort: selectedPort. 
	
	aMorph := self new initializeWithModel: model.
	
	aMorph addMorph: graphView canvas buildMorph.
	^ aMorph
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph >> changePort: newPort [
	| tempModel |
	tempModel := ArduinoSerial initializeWithPort: newPort.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph >> closePort [    self model close.
]

{ #category : #initialization }
ArduinoSerialGraphMorph >> initializeWithModel: newModel [
   self model: newModel.


]

{ #category : #display }
ArduinoSerialGraphMorph >> openInWorld [
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
ArduinoSerialGraphMorph >> step [
    self model announcer announce: RubTextUpdatedInModel
]

{ #category : #'model - stepping' }
ArduinoSerialGraphMorph >> stepTime [
    ^1000
]
