'
' listComPorts -- List all COM, even USB-to-serial-based onesports,
'                 along with other info about them
'
' Execute on the command line with:
'   cscript.exe //nologo listComPorts.vbs
'
' http://github.com/todbot/usbSearch
'
' 2012, Tod E. Kurt, http://todbot.com/blog/
'
' core idea stolen from
' http://collectns.blogspot.com/2011/11/vbscript-for-detecting-usb-serial-com.html
' And this is fun, if not particularly useful:
' http://henryranch.net/software/jwmi-query-windows-wmi-from-java/
' 
On Error Resume Next
Set portList = GetComPorts()

portnames = portList.Keys
Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile("comPorts.txt",2,true)
for each pname in portnames
    Set portinfo = portList.item(pname)
    wscript.echo pname & " - " & _
           portinfo.Manufacturer & " - " & _
           portinfo.PNPDeviceID & _
           ""
           'portinfo.Name & " - "
	objFileToWrite.WriteLine(pname)
Next
objFileToWrite.Close
Set objFileToWrite = Nothing

'
' For all the keys in an entity, see
'http://msdn.microsoft.com/en-us/library/windows/desktop/aa394353(v=vs.85).aspx
'
Function GetComPorts()
    set portList = CreateObject("Scripting.Dictionary")

    strComputer = "."
    set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
    set colItems = objWMIService.ExecQuery _
        ("Select * from Win32_PnPEntity")
    for each objItem in colItems
        set objRgx = New RegExp
		with objRgx
			.Pattern = "COM[0-9]+"
			.Global = False
		End With
		strDevName = objItem.Name
        if len(strDevName) > 0 Then
			set objRegMatches = objRgx.Execute(strDevName)
			if objRegMatches.Count = 1 then
				portList.Add objRegMatches.Item(0).Value, objItem 
			end if
		end if
        
    Next
    set GetComPorts = portList
End Function


