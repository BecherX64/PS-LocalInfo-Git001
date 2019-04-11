# Author: Ivan Batis
# Script.ps1
# Comment: Output Saved as HTML

Param(
[string]$OutPutServiceHtml = "Services.Html",
[string]$OutPutNetworkHtml = "Network.Html",
	[string]$OutPutComputerkHtml = "Computer.Html"
)

$Date = get-date -format yyyy-MM-dd
$Time = get-date -format HH:mm

$OutPutDir = "C:\Temp"

if (!(Test-Path $OutPutDir))
{
	New-Item -ItemType Directory -Path $OutPutDir
}

#$Output = $OutPutDir + "\OutPut_" + $date + ".txt"
$OutputService = $OutPutDir + "\" + $OutPutServiceHtml
$OutputNetwork = $OutPutDir + "\" + $OutPutNetworkHtml
$OutputComputer = $OutPutDir + "\" + $OutPutComputerkHtml
If (Test-Path $OutputService) 
{
	Remove-Item $OutputService
}

If (Test-Path $OutputNetwork) 
{
	Remove-Item $OutputNetwork
}

If (Test-Path $OutputComputer)
{
	Remove-Item $OutputComputer
}

#ComputerInfo
$osInfo = Get-CimInstance Win32_OperatingSystem
$computerInfo = Get-CimInstance Win32_ComputerSystem
$diskInfo = Get-CimInstance Win32_LogicalDisk

$ObjComputer = @()

$ComputerReportLine = New-Object PSCustomObject | select ComputerName, OS, OSVersion, Domain, Workgroup, DomainJoined, Disks, Date, Time

$ComputerReportLine.ComputerName = $computerInfo.Name
$ComputerReportLine.OS = $osInfo.Caption
$ComputerReportLine.OSVersion  = "$($osInfo.Version) Build $($osInfo.BuildNumber)"
$ComputerReportLine.Domain = $computerInfo.Domain
$ComputerReportLine.Workgroup = $computerInfo.Workgroup
$ComputerReportLine.DomainJoined = $computerInfo.PartOfDomain
$ComputerReportLine.Disks = $diskInfo.DeviceID
$ComputerReportLine.Date = $Date
$ComputerReportLine.Time = $Time

$ObjComputer = $ComputerReportLine

$ComputerInfoHtml = $objComputer | Select-Object * | ConvertTo-Html -CssUri "TableStyle.css" -Head "----=====Computer Info====-----" -Title "Title: Computer Info"
$ComputerInfoHtml | Add-Content $OutputComputer


#Runnig Service Info
$services = Get-Service
$ServicesHtml = $services | Select-Object Name,Status,StartType | ConvertTo-Html -CssUri "TableStyle.css" -Head "----=====Running Services====-----" -Title "Title: Running Services"
$ServicesHtml | Add-Content $OutputService

#Network Card Info
$NetworkCard = Get-NetAdapter | where {$_.status -like "Up"}
$ObjNetworkCard = @()
Foreach ($NIC in $NetworkCard)
{
	$IpConfing = Get-NetIPAddress -InterfaceIndex $NIC.ifIndex
	ForEach ($IP in $IpConfing)
	{
		
		$ReportLine = New-Object PSCustomObject | select IPAddress, AddressFamily
		$ReportLine.IPAddress = $IP.IPAddress
		$ReportLine.AddressFamily = $IP.AddressFamily
		$ObjNetworkCard += $ReportLine	
	}
}

$NetworkCardHtml = $ObjNetworkCard | Select-Object IPAddress, AddressFamily | ConvertTo-Html -CssUri "TableStyle.css" -Head "----=====IP Address====-----" -Title "Title: IPAddress"
$NetworkCardHtml | Add-Content $OutputNetwork




