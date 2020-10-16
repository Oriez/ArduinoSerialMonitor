Class {
	#name : #ArduinoSerialGraphMorph,
	#superclass : #ArduinoSerialBasicMorph,
	#instVars : [
		'updateGraph'
	],
	#category : #SerialMonitorViews
}

{ #category : #initialization }
ArduinoSerialGraphMorph class >> initialize: selectedPort baud: selectedBaud [
	| points ds graphView model aMorph graph updateGraphFunc canv |
	points := #(0).

    graph := RTDynamicStackedGrapher new.
    graph numberOfBars: 10.
    graph
        minY: -100;
        maxY: 100.
    graph y: #yourself.
    graph barShape color: (Color red alpha: 0.3).

	
	aMorph  := RubScrolledTextMorph new.
	graphView := graph build.
	
	updateGraphFunc := [ :number |
		graph add: number
		]. 
	model := ArduinoSerialGraph initializeWithPortAndGraphData: selectedPort updateGraph: updateGraphFunc baud: selectedBaud. 
	
	aMorph := self new initializeWithModel: model updateGraph: updateGraphFunc.
	canv := graphView canvas.
	aMorph addMorph: canv buildMorph.
	^ aMorph
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph class >> open [
    self new openInWorld
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph >> changeBaudRate: newBaudRate [
	| tempModel currentPort |
	currentPort := self getSelectedPort.
	tempModel := ArduinoSerialGraph initializeWithPortAndGraphData: selectedPort updateGraph: updateGraph baud:  selectedBaud. 
	self setSelectedBaud: newBaudRate.
   self model: tempModel.
]

{ #category : #'as yet unclassified' }
ArduinoSerialGraphMorph >> changePort: newPort [
	| tempModel currentBaud |
	currentBaud := self getSelectedBaud.
	tempModel := ArduinoSerialGraph initializeWithPortAndGraphData: selectedPort updateGraph: updateGraph baud:  selectedBaud. 
	self setSelectedPort: newPort.
   self model: tempModel.

]

{ #category : #initialization }
ArduinoSerialGraphMorph >> initialize [
	| tempModel |
	super initialize.
	tempModel := ArduinoSerialGraph initializeWithPortAndGraphData: '/dev/cu.wchusbserial1410' updateGraph: updateGraph baud: 9600.
   self model: tempModel.
]

{ #category : #initialization }
ArduinoSerialGraphMorph >> initializeWithModel: newModel updateGraph: aUpdateGraph [
	
	updateGraph := aUpdateGraph.
   self model: newModel.

]

{ #category : #'model - stepping' }
ArduinoSerialGraphMorph >> stepTime [
    ^100
]
