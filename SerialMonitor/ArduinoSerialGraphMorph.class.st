Class {
	#name : #ArduinoSerialGraphMorph,
	#superclass : #ArduinoSerialBasicMorph,
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
	
	aMorph := self new initialize: model.
	
	aMorph addMorph: graphView canvas buildMorph.
	^ aMorph
]

{ #category : #initialization }
ArduinoSerialGraphMorph class >> initialize: selectedPort baud: selectedBaud [
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

	model := ArduinoSerial initializeWithArgs: selectedPort baud: selectedBaud. 
	
	aMorph := self new initialize: model.
	
	aMorph addMorph: graphView canvas buildMorph.
	^ aMorph
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph class >> open [
    self new openInWorld
]

{ #category : #'model - stepping' }
ArduinoSerialGraphMorph >> stepTime [
    ^1000
]
