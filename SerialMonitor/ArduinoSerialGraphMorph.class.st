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
ArduinoSerialGraphMorph class >> initialize: selectedPort baud: selectedBaud [
	| points1 ds graphView model aMorph graph updateGraph |
	points1 := #(5 8 5 9).

	graph := RTGrapher new.
	
	ds := RTData new.
	ds points: points1.
	ds connectColor: Color blue.
	ds y: #yourself.
	graph add: ds.

	updateGraph := [ :points |
		graph cleanView.
		ds := RTData new.
		ds points: points.
		ds connectColor: Color blue.
		ds y: #yourself.
		graph add: ds.
		graph render ].
	
	graph axisX noLabel; noTick.
	aMorph  := RubScrolledTextMorph new.
	graphView := graph build.

	model := ArduinoSerialGraph initializeWithPortAndGraphData: selectedPort updateGraph: updateGraph baud:  selectedBaud. 
	
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
