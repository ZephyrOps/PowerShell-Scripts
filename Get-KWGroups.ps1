<#
.SYNOPSIS
Get-KWGroups queries AD for groups that contain a common keyword string.
.DESCRIPTION
Get-KWGroups uses Get-ADGroup to dynamically query names using the -Filter parameter of the command. 
It displays each matching group's name, CanonicalName, and Creation date as output.
.PARAMETER match
The keyword string used to filter group names. You can also use the parameter -query to bind the match string.
.PARAMETER LDAP
A string containing an LDAP filter to narrow the Search Base and speed up script runtime. You can also use the
parameter -target to bind the LDAP string.
.PARAMETER remotetarget
A not-yet-instantiated command for exporting a .csv of the output to a remote computer.
.EXAMPLE
Get-KWGroups -match 'Boston TSG' -LDAP "OU=Americas,DC=BAIN,DC=com"

Finds all groups with 'Boston TSG' in their names in the Americas OU.
.EXAMPLE
Get-KWGroups -q 'Iris'

Finds all groups with 'Iris' in their names using the shortened version of the -query alias.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True,HelpMessage='Please enter a keyword string to search for similar groups')]
    [Alias('query')]
    [String] $match,
    [Parameter(Mandatory=$False)]
    [String] $LDAP,
    [Parameter(Mandatory=$False,HelpMessage="'Please enter a samAccountName to run this command on a user`'s machine")]
    [Alias('target')]
    [string] $remotetarget
    )

if ($remotetarget -ne $null) {
    Get-WmiObject -class Win32_LogicalDisk -ComputerName $remotetarget | Get-Member
}    
Get-ADGroup -Filter "Name -like '*$match*'" -Properties * | 
Select-Object name,CanonicalName,Created