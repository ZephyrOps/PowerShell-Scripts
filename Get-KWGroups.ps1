<# This script can be used to find a list of all groups with a certain keyword in their name. #>
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
