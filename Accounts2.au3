#AutoIt3Wrapper_Change2CUI=y
#include <Array.au3>
#Local $Sets[];

# The number of accounts to launch at once
Global $setSize = 8

# The number of accounts from the list below to skip. For example, if you have 20 accounts and you went through 10 and then stopped, you could set this to 10 and launch this script again later to resume from there
Local $skip = 0

# Comma separated list of all the account IDs you want to launch. This can be found by right clicking the account -> Edit -> Statistics,
Local $accounts=[2,3,4,5,12,7,13,9,10,11,14,15,16,17,18,19,20,21,22,79,24,25,80,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230]


Local $skipped = 0

Local $i = 0
Local $setNum = 1
Local $thisSet[0]

For $element in $accounts
	If $i < $setSize Then
		If $skipped+1 > $skip Then
			_ArrayAdd($thisSet, $element)
		Else
			$skipped = $skipped+1
		EndIf
		
		$i = $i+1
		
		If $i = $setSize Then	
			#MsgBox(0,"Success",Ubound($thisSet))
			If Ubound($thisSet) > 0 Then
				LaunchSet($setNum,$thisSet)
			EndIf
			$i = 0
			local $thisSet[0]
			$setNum = $setNum+1
		EndIf
	EndIf
Next

Func LaunchSet($setNum,$thisSet)
	VPNConnect($setNum)
	LaunchAccounts($setNum,$thisSet)
EndFunc

Func VPNConnect($setNum)
	# A somewhat random choice of what VPN server number to start with. Every set of accounts will increment this by 1 and connect to that VPN server.
	$vpn = $setNum + 8925
	Run('c:\Program Files\NordVPN\NordVPN.exe -c -n "United States #' & $vpn & '"')
	Sleep(3000)
EndFunc

Func LaunchAccounts($setNum,$thisSet)
	Local $cmdString
	Local $elementCount = Ubound($thisSet)
	Local $startedAccounts[$elementcount]
	For $i=0 to $elementCount-1
		$startedAccounts[$i] = 0
	Next
		
	Local $stoppedAccounts[$elementcount]
	For $i=0 to $elementCount-1
		$stoppedAccounts[$i] = 0
	Next
	
	$i=0
	For $element in $thisSet
		$i += 1
		$cmdString=$cmdString & $element
		If $i < $elementCount Then
			$cmdString=$cmdString & ","
		EndIf
	Next
	# This is the path to your GW2Launcher.exe
	Run('c:\!!Path\!!To\!!GW2Launcher\Gw2Launcher.exe -l:uid:' & $cmdString)
	
	For $i=0 to $elementCount-1
		$windowNum = (($setNum-1)*$setSize)+($i+1)
		$windowTitle = "z_Freebie" & $windowNum
		WinWait($windowTitle)
		$success = false
		While $success = false
			Local $clientSize = WinGetClientSize($windowTitle)
			If @error = 0 Then
				If $clientSize[0] <> 1120 And $clientSize[1] <> 976 Then
					#MsgBox(0,"Success",$windowTitle)
					$success = true
				EndIf
			EndIf
		WEnd
	Next
	
	For $i=0 to $elementCount-1
		$windowNum = (($setNum-1)*$setSize)+($i+1)
		$windowTitle = "z_Freebie" & $windowNum
		WinWaitClose($windowTitle)
	Next
EndFunc


#TrayTip ( "Debug", "Result: " & $ThisSet[0], 10)
