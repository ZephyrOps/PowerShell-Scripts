<# This script can be used to find a list of all groups with a certain sub-string in their name.
You can select which properties to use in the export by changing the properties in the Select-Object command of the scriptBlock. #>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True,HelpMessage='Please enter a keyword string to search for similar groups')
    [Alias('query')]
    [String] $match,
    [Parameter(Mandatory=$False)]
    [String] $LDAP
    )
Get-ADGroup -Filter "Name -like '*$match*'" -Properties * | 
Select-Object name,CanonicalName,Created
