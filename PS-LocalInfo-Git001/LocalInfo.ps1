# Author: Ivan Batis
# Script.ps1
# Comment: Dir checks added

$Date = get-date -format yyyy-MM-dd
$Time = get-date -format HH:mm

$OutPutDir = "C:\Temp"

if (!(Test-Path $OutPutDir))
{
	New-Item -ItemType Directory -Path $OutPutDir
}

#$Output = $OutPutDir + "\OutPut_" + $date + ".txt"
$Output = $OutPutDir + "\OutPut.txt"
If (Test-Path $Output) 
{
	Remove-Item $Output
}

$services = Get-Service
$ComputerInfo = Get-WMIObject Win32_ComputerSystem
"Computer Name:" + $ComputerInfo.Name | Add-Content $Output
"Current date & time: " + $Date +" "+ $Time| Add-Content $Output


"----=====Computer Info====-----" | Add-Content $Output
$ComputerInfo.Properties | ForEach-Object `
	{
		$_.Name +";" + $_.Value | Add-Content $Output
	}

"----=====Running Services====-----"  | Add-Content $Output
"ServiceName;Status" | Add-Content $Output
Foreach ($service in $services)
{
	$service.Name +";"+ $service.Status +";"+ $service.StartType | Add-Content $Output
}


"----=====IP Address====-----"  | Add-Content $Output
"IPAddress;AddressFamily" | Add-Content $Output

$NetworkCard = Get-NetAdapter | where {$_.status -like "Up"}
Foreach ($NIC in $NetworkCard)
{
	$IpConfing = Get-NetIPAddress -InterfaceIndex $NIC.ifIndex
	ForEach ($IP in $IpConfing)
	{
		$IP.IPAddress +";"+$IP.AddressFamily | Add-Content $Output
	}
}