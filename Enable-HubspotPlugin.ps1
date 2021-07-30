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
    [Parameter(Mandatory=$True,HelpMessage="Please enter the employee Code of the user you`'d like to Enable Hubspot for")]
    [String] $EmployeeCode,
    [Parameter(Mandatory=$False)]
    [Bool] $test=$True
)

if (Get-Module -ListAvailable -Name "AzureAD") {
    Write-Host "The AzureAD module is installed. Proceeding..." -ForegroundColor "Green"
}   else {
        Write-Host "The AzureAD module is not installed. Installing the latest version..." -ForegroundColor "Yellow"
        Install-Module -name "AzureAD"
}

$NULL = Connect-AzureAD # Proceed through MFA sign-in prompt to authenticate elevated account credentials
$hubSpotGroup = Get-AzureADGroup -searchString "HubSpot Enable Outlook Add-in"
$user = Get-AzureADUser -searchString $EmployeeCode

Add-AzureADGroupMember -objectID $hubSpotGroup.objectID -refObjectID $user.ObjectID
Write-Host "User '$($user.DisplayName)' was successfully added to the '$($hubSpotGroup.DisplayName)' group in Azure AD." -ForegroundColor "Green"

if ($test=$True) {
    Remove-AzureADGroupMember -memberID $user.objectID -objectID $hubSpotGroup.objectID
    Write-Host "User '$($user.DisplayName) was successfully removed from the '$($hubSpotGroup.DisplayName)' group in Azure AD" -ForegroundColor "Yellow"
}
