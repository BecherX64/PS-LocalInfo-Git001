# Author: Ivan Batis
# Script.ps1
# Comment: Dir checks added

$Date = get-date -format yyyy-MM-dd
$Time = get-date -format HH-mm

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
Write-Host "Computer Name:" $ComputerInfo.Name -ForegroundColor Green | Add-Content $Output
Write-Host "----=====Computer Info====-----" -ForegroundColor Green | Add-Content $Output
$ComputerInfo.Properties | ForEach-Object `
	{
		$_.Name +";" + $_.Value | Add-Content $Output
	}

Write-Host "----=====Running Services====-----" -ForegroundColor Green | Add-Content $Output
Foreach ($service in $services)
{
	Write-Host $service.Name ";" $service.Status ";" $service.StartType | Add-Content $Output
}
