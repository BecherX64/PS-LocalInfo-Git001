# Author: Ivan Batis
# Script.ps1
# Last Saved: Today

#Branch 02 & Commit 03

$Output = "C:\Temp\OutPut_" + $date + "_" + $Time + ".txt"
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
