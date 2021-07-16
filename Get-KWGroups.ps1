<# This script can be used to find a list of all groups with a certain keyword in their name. #>
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
Get-ADGroup -Filter "Name -like '*$match*'" -Properties * | 
Select-Object name,CanonicalName,Created
#if ($remotetarget -ne $null) {
#    Invoke-Command -ScriptBlock {
#        Get-ADGroup -Filter "Name -like '*$match*'" -Properties * | 
#        Select-Object name,CanonicalName,Created | 
#        Export-Csv -path "$HOME\Desktop\Name Like $($match).csv" -NoTypeInformation
#    }