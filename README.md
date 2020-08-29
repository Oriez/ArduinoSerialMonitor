# ArduinoSerialMonitor
Pharo implemintation for Arduino Serial Monitor

# Installation
Use iceberg to clone this repository (`https://github.com/Oriez/ArduinoSerialMonitor.git`).
# Usage
You will find 2 packages -
* `SerialMonitor` - The graphical modules 
* `SerialStuff` - The serial functions classes

To run the serial monitor in the Playground - `ArduinoSerialBrowser new openWithSpec.`
(assuming you have an Arduino connected to your PC)

# Available views
* Basic - Text view, like in Arduino IDE.
* Map - Show realtime location (text should be formatted like this `<lat>@<lon>`)
* Graph - TODO

### How to add a new view?

