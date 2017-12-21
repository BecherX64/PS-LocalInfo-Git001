# Author: Ivan Batis
# Script.ps1
#
$services = Get-Service
$ComputerInfo = Get-WMIObject Win32_ComputerSystem
Write-Host "----=====Computer Info====-----" -ForegroundColor Green
$ComputerInfo.Properties | ForEach-Object `
	{
		$_.Name +";" + $_.Value
	}

Write-Host "----=====Running Services====-----" -ForegroundColor Green
Foreach ($service in $services)
{
	Write-Host $service.Name ";" $service.Status ";" $service.StartType

}