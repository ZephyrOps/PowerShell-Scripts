<# This script can be used to export a .csv list of all groups with a certain sub-string in their name.

You can select which properties to use in the export by changing the properties in the second line of the scriptBlock.

You will need to include a Path for the Export-CSV command to complete the export. You can also omit it to run it in-line. #>

Get-ADGroup -Filter { Name -like '*MATCH_STRING*' } -Properties * |
Select-Object samAccountName,Name |
Export-CSV -Path PATH_HERE.csv -NoTypeInformation
