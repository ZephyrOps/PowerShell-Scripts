<#
.SYNOPSIS
This script is used to enable the HubSpot plugin in Outlook for the Desktop application and the Office 365 Online version.
.PARAMETER User
This parameter accepts an employee code or object ID.
.PARAMETER test
This parameter can be used to confirm which groups you are adding a User to. It will both add and remove the User from the
group and Write-Host the results.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,HelpMessage="Please enter the employee Code of the User you`'d like to Enable Hubspot for")]
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
$SelectGroups = Get-AzureADGroup -searchString "HubSpot" | Out-GridView -Title "Select the groups you would like to change" -PassThru
$User = Get-AzureADUser -searchString $EmployeeCode

foreach ($Group in $SelectGroups) {
    if ($NULL -ne $Group.OnPremisesSecurityIdentifier) { # This group in an on-premises Active Directory group
        Add-ADGroupMember -Identity $Group.DisplayName -Members $EmployeeCode
        Write-Host "User '$($User.DisplayName)' was successfully added to the '$($Group.DisplayName)' group in AD." -ForegroundColor "Green"
    } else {
        Add-AzureADGroupMember -objectID $Group.objectID -refObjectID $User.ObjectID
        Write-Host "User '$($User.DisplayName)' was successfully added to the '$($Group.DisplayName)' group in Azure AD." -ForegroundColor "Green"
    }
}

if ($test=$True) {
    foreach ($Group in $SelectGroups) {
        if ($NULL -ne $Group.OnPremisesSecurityIdentifier) {
            Remove-ADGroupMember -Identity $Group.DisplayName -Members $EmployeeCode -Confirm:$False
            Write-Host "User '$($User.DisplayName)' was successfully removed from the '$($Group.DisplayName)' group in AD." -ForegroundColor "Yellow"
        } else {
            Remove-AzureADGroupMember -memberID $User.objectID -objectID $Group.objectID
            Write-Host "User '$($User.DisplayName)' was successfully removed from the '$($Group.DisplayName)' group in Azure AD." -ForegroundColor "Yellow"
        }
    }
}
Disconnect-AzureAD
exit

<# To-do Feature Implementation:
- Allow the user to specify the search string from command line (parameterized)
- Allow the user to specify the search base by combining other similar scripts
- Transition to Write-Verbose and Write-output
- Allow the user to see feedback between adds/removes by also pulling membership before and after
- Actually validate group changes via new queries and not just successful cmdlet runs
- Create a basic GUI for the script.
- Find a way to pull MFA prompt to top or make it readily accessible.
- Update help for all features
- Validate inputs at each step for Out-GridView no choice.
- Create a log template for changes.
- Use log to generate automated email informing user of changes.
- Allow user to specify add/remove and change workflow accordingly.
- Show group membership if below X? size #>