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
    [String] $LDAP=''
    )

if ($LDAP -eq '') {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Get-ADGroup -Filter "Name -like '*$match*'" -Properties * | 
    Select-Object name,CanonicalName,Created
    $stopwatch.Stop()
    Write-Verbose "Without an LDAP filter, this script took $($stopwatch.ElapsedMilliseconds/1000.0) seconds to run and returned $($result.Count) results."
} else {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Get-ADGroup -Filter "Name -like '*$match*'" -searchBase $LDAP -Properties * | 
    Select-Object name,CanonicalName,Created
    $stopwatch.Stop()
    Write-Verbose "With an LDAP filter, this script took $($stopwatch.ElapsedMilliseconds/1000.0) seconds to run and returned $($result.Count) results."
}

Write-Output $result