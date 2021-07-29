<#
.SYNOPSIS
This script is used to enable the HubSpot plugin in Outlook for the Desktop application and the Office 365 Online version.
.PARAMETER user
This parameter accepts an employee code or object ID.
.PARAMETER test
This parameter can be used to confirm which groups you are adding a user to. It will both add and remove the user from the
group and Write-Host the results.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,HelpMessage="Please enter the E-Code of the user you`'d like to enable the Hubspot plugin for")]
    [String] $ecode,
    [Parameter(Mandatory=$False)]
    [Bool] $test=$False
)

if (Get-Module -ListAvailable -Name "AzureAD") {
    Write-Host "The AzureAD module is installed. Proceeding..." -ForegroundColor "Green"
}   else {
        Write-Host "The AzureAD module is not installed. Installing the latest version..." -ForegroundColor "Yellow"
        Install-Module -name "AzureAD"
}

Connect-AzureAD # Proceed through MFA sign-in prompt to authenticate elevated account credentials
$hubSpotGroups = Get-AzureADGroup -searchString "HubSpot"
$user = Get-AzureADUser -searchString $ecode
$userID = $user.objectID

foreach ($group in $hubSpotGroups) {
    Add-AzureADGroupMember -objectID $group.objectID -refObjectID $userID
}

if ($test=$True) {
    foreach ($group in $hubSpotGroups) {
        Remove-AzureADGroupMember -memberID $user.objectID -objectID $group.objectID
    }
}
