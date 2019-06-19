#
$file = ".\WebPage\Index.html"
$pattern = "Version 2."
$Error.Clear()

$CurentPath = pwd
Write-Host "Curent path:" $CurentPath
#ls $file

If (Test-Path $file)
{
	$content = Get-Content $file
	Write-Host "Looking for pattern:" $pattern
	$select = $content | Select-String -Pattern $pattern

	if ($select) 
	{
		Write-Host "String found:" $select
	} else 
	{
		throw "Required String or file not found"
	}

} else 
{
	Write-Host "something went wrong"
	throw $Error
}


