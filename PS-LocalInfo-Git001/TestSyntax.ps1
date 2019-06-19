#
$file = ".\PS-LocalInfo-Git001\WebPage\Index.html"
$pattern = "Version 1."
$Error.Clear()

$CurentPath = pwd
Write-Host "Curent path:" $CurentPath
try 
{
	Write-host "File to check:" (ls $file).fullname
	Write-Host "Looking for pattern:" $pattern
}

Catch 
{             
   Write-host "File NOT found:" $_.Exception.Message
   $Error.Clear()
}


If (Test-Path $file)
{
	$content = Get-Content $file
	$select = $content | Select-String -Pattern $pattern

	if ($select) 
	{
		Write-Host "String found:" $select
	} else 
	{
		throw "Required pattern not found in given file"
	}

} else 
{
	Write-Host "something went wrong"
	throw $Error
}


