<# This script can be used to find a list of all groups with a certain sub-string in their name.
You can select which properties to use in the export by changing the properties in the Select-Object command of the scriptBlock. #>

param ([String] $match = '')

if ($match -eq '') { $match = Read-Host "Please enter a match string to search group names" }

Get-ADGroup -Filter "Name -like '*$match*'" -Properties * | 
Select-Object name,CanonicalName,Created
