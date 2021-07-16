<#
.SYNOPSIS
Get-KWGroups queries AD for groups that contain a common keyword string.
.DESCRIPTION
Get-KWGroups uses Get-ADGroup to dynamically query names using the -Filter parameter of the command. 
It displays each matching group's name, CanonicalName, and Creation date as output.
.PARAMETER match
The keyword string used to filter group names. You can also use the parameter -query to bind the match string.
.PARAMETER ldap
A string containing an LDAP filter to narrow the Search Base and speed up script runtime. You can also use the
parameter -target to bind the LDAP string.
.PARAMETER customerSAN
A string containing a valid samAccountName that can be used to search for an email address using the AD Services Interface
and send an email containing a .csv of the export.
.EXAMPLE
Get-KWGroups -match 'Boston TSG' -LDAP "OU=Americas,DC=BAIN,DC=com"
Finds all groups with 'Boston TSG' in their names in the Americas OU.
.EXAMPLE
Get-KWGroups -q 'Iris' -email 44724
Finds all groups with 'Iris' in their names using the shortened version of the -query alias. Sends the results as a .csv to user 44274 via email.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True,HelpMessage='Please enter a keyword string to search for similar groups')]
    [Alias('query')]
    [String] $match,
    [Parameter(Mandatory=$False)]
    [String] $ldap='',
    [Parameter(Mandatory=$False)]
    [Alias('email')]
    [string] $customerSAN=''
    )

if ($LDAP -eq '') {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Get-ADGroup -Filter "Name -like '*$match*'" -Properties name,CanonicalName,created | 
    Select-Object name,CanonicalName,Created
    $stopwatch.Stop()
    Write-Verbose "Without an LDAP filter, this script took $($stopwatch.ElapsedMilliseconds/1000.0) seconds to run and returned $($result.Count) results."
} else {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Get-ADGroup -Filter "Name -like '*$match*'" -searchBase $LDAP -Properties name,CanonicalName,created | 
    Select-Object name,CanonicalName,Created
    $stopwatch.Stop()
    Write-Verbose "With an LDAP filter, this script took $($stopwatch.ElapsedMilliseconds/1000.0) seconds to run and returned $($result.Count) results."
}

if ($customerSAN -ne '') {
    $senderEmail = ([adsi]"LDAP://$(whoami /fqdn)")
    $senderEmail = $senderEmail.mail
    $customerEmail = Get-ADUser -Identity $customerSAN -Properties mail | Select-Object -expandProperty mail
    $reportDir = "$HOME\Desktop\Name Like $($match).csv"
    $result | Export-CSV -path $reportdir -NoTypeInformation
    Send-MailMessage -To "$customerEmail" -Subject "Group Search on $($match) Keyword - CSV Export" -Body "Please see the requested export via the attached .csv" -Attachments $reportdir -Smtpserver "mail.americas.bain.com" -From "$senderEmail"
} else {
    return $result
}